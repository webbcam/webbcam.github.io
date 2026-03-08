---
title: "Maximizing Ollama inference speed on M4 Mac mini"
date: 2026-03-07 23:30:16 -0500
categories: [resources, ollama]
tags: [ollama, local, qwen3.5, mac, mini, m4, performance]
---
> [!NOTE]
> *This doc was generated with the help of Claude for researching how to improve response times of running Qwen3.5:9B on my Mac mini m4 (24GB) using Ollama. Posting this as a guide and resource for referring back to in future"*

**The base M4 Mac mini with 24GB unified memory can generate tokens at 28–35 tokens/sec with 8B-class models using Q4_K_M quantization** — fast enough for responsive interactive use. The primary bottleneck is the chip’s **120 GB/s memory bandwidth**, not compute,   which means the biggest gains come from keeping models small (lower quantization), enabling flash attention and KV cache quantization, and ensuring 100% GPU offloading via Metal. This guide covers every actionable optimization, from environment variables to system-level tuning, with specific commands you can copy-paste.

The M4’s unified memory architecture means your 24GB of RAM *is* your VRAM — no data copying between CPU and GPU.  A 9B Q4_K_M model uses roughly 5–6GB, leaving ample room for KV cache and macOS overhead. The key is configuring Ollama correctly and eliminating anything that competes for memory bandwidth.

-----

## Essential Ollama environment variables to set first

Nearly all Ollama tuning happens through environment variables, not command-line flags.  **The critical detail on macOS**: if you installed Ollama via the .dmg app, setting variables in `~/.zshrc` does nothing — the app doesn’t read shell configs. You must use `launchctl setenv`, then quit and reopen Ollama from the menu bar.  

```bash
# === Core performance settings (copy-paste this block) ===
launchctl setenv OLLAMA_FLASH_ATTENTION "1"
launchctl setenv OLLAMA_KV_CACHE_TYPE "q8_0"
launchctl setenv OLLAMA_KEEP_ALIVE "-1"
launchctl setenv OLLAMA_MAX_LOADED_MODELS "1"
launchctl setenv OLLAMA_CONTEXT_LENGTH "8192"

# Verify they took effect:
launchctl getenv OLLAMA_FLASH_ATTENTION   # Should return: 1

# Then: Quit Ollama from menu bar → Reopen
```

What each does and why it matters:

**`OLLAMA_FLASH_ATTENTION=1`** enables flash attention on Metal, reducing memory consumption with no quality penalty.  This is a prerequisite for KV cache quantization and is expected to become Ollama’s default. There is no downside — if a model doesn’t support it, Ollama silently falls back to F16. 

**`OLLAMA_KV_CACHE_TYPE=q8_0`** halves the KV cache memory footprint.  At 32K context, the KV cache for an 8B model drops from ~4.5GB (F16) to ~2.3GB (Q8). Quality impact is negligible.  One caveat: some users report slight performance regressions on Metal specifically — benchmark before and after, and revert to `f16` if generation slows.  

**`OLLAMA_KEEP_ALIVE="-1"`** keeps models loaded in memory indefinitely, eliminating the 2–10 second reload penalty between conversations.   On a dedicated inference machine, this is a no-brainer.

**`OLLAMA_MAX_LOADED_MODELS=1`** prevents Ollama from loading multiple models simultaneously. On 24GB, running two models concurrently splits your memory budget and causes swapping.

For Homebrew installs, add the equivalent `export` statements to `~/.zshrc` and run `brew services restart ollama`. 

|Variable                  |Default|Recommended      |Effect                                  |
|--------------------------|-------|-----------------|----------------------------------------|
|`OLLAMA_FLASH_ATTENTION`  |`0`    |**`1`**          |Enables flash attention on Metal        |
|`OLLAMA_KV_CACHE_TYPE`    |`f16`  |**`q8_0`**       |Quantizes KV cache, halves its memory   |
|`OLLAMA_KEEP_ALIVE`       |`5m`   |**`-1`**         |Model stays loaded forever              |
|`OLLAMA_MAX_LOADED_MODELS`|auto   |**`1`**          |Single model to avoid memory competition|
|`OLLAMA_CONTEXT_LENGTH`   |`2048` |**`8192`**       |Larger default context window           |
|`OLLAMA_NUM_PARALLEL`     |`1`    |`1`              |Leave default for single-user           |
|`OLLAMA_DEBUG`            |`0`    |`1` (temporarily)|Shows Metal loading, layer offload info |

-----

## Verifying Metal GPU acceleration and monitoring performance

Metal GPU acceleration is compiled into the Ollama binary and activates automatically on Apple Silicon.  **Never run Ollama inside Docker on macOS** — Docker containers cannot access Metal, forcing CPU-only mode  that is 5–10× slower. 

```bash
# PRIMARY CHECK — run after loading any model:
ollama ps
# Expected output:
# NAME         ID          SIZE    PROCESSOR    UNTIL
# qwen3:8b     abc123...   5.2 GB  100% GPU    Forever

# If you see "100% CPU" → something is wrong
```

For deeper verification, enable debug mode and check the logs:

```bash
# Run in debug mode:
OLLAMA_DEBUG=1 ollama serve

# Look for these key log lines:
# "Dynamic LLM libraries [metal]"           → Metal backend loaded ✅
# "offloaded 37/37 layers to GPU"           → All layers on GPU ✅
# "flash_attn = 1"                          → Flash attention active ✅
# "type_k = 'q8_0', type_v = 'q8_0'"       → KV cache quantized ✅
```

For real-time monitoring during inference, **macmon** is the best tool because it requires no sudo:

```bash
brew install vladkens/tap/macmon
macmon    # Shows GPU utilization, memory bandwidth, power, temps

# Alternative (requires sudo):
pip install asitop
sudo asitop --interval 1

# Spot-check thermals:
sudo powermetrics --samplers smc -i 1000 -n 1 | grep -i "temp"
```

During active inference, you should see high GPU utilization and significant memory bandwidth consumption in macmon. CPU utilization should be relatively low — if CPU is spiking instead of GPU, Metal isn’t engaged.

-----

## Quantization sweet spots for 9B models on 24GB

Since LLM token generation is memory-bandwidth-bound, **smaller quantizations generate tokens faster** because fewer bytes must be read from memory per token.   The tradeoff is quality. For an 8–9B parameter model on 24GB, you have generous headroom — the decision is speed vs. fidelity.

|Quantization|File size (8B model)|Generation speed (M4)|Quality loss|Best for                    |
|------------|--------------------|---------------------|------------|----------------------------|
|**Q4_K_M**  |**~5.2 GB**         |**~30–35 t/s**       |Minimal     |Speed-sensitive chat, coding|
|Q5_K_M      |~5.8 GB             |~25–32 t/s           |Very low    |Balanced quality/speed      |
|Q6_K        |~6.5 GB             |~23–28 t/s           |Nearly none |Quality-sensitive tasks     |
|Q8_0        |~8.9 GB             |~22–26 t/s           |Negligible  |Maximum fidelity            |
|FP16        |~16 GB              |Not recommended      |None        |Leaves no room for KV cache |

**Q4_K_M is the recommended default** for most users.   At 5.2GB, it leaves ~15GB free for macOS, KV cache, and overhead  — enough for 32K context with room to spare. The perplexity increase over FP16 is roughly +0.05, imperceptible in interactive use.  

**Q5_K_M is worth the ~10% speed penalty** if you’re doing reasoning, code generation, or creative writing where subtle quality differences matter.  At 5.8GB it still fits trivially.

**Q8_0 at 8.9GB is feasible but overkill** for most 8B models — the quality gain over Q5_K_M is marginal while consuming 50% more memory.  Reserve Q8 for when you’re running a smaller model (4B or below) and have memory to burn.

### Memory budget calculator

```
Total RAM:                          24 GB
macOS + system services:           -4 GB
─────────────────────────────────────────
Available for model + KV cache:    ~20 GB

Example: Qwen3 8B Q4_K_M + 32K context (Q8 KV cache)
  Model weights:    5.2 GB
  KV cache (Q8):    2.3 GB
  Runtime overhead: 0.5 GB
  Total:           ~8.0 GB  → Comfortable ✅ (12GB headroom)

Example: Qwen3 14B Q4_K_M + 16K context (Q8 KV cache)
  Model weights:    9.3 GB
  KV cache (Q8):    1.7 GB
  Runtime overhead: 0.5 GB
  Total:           ~11.5 GB → Comfortable ✅
```

-----

## Qwen3 model-specific optimizations

Qwen offers two relevant model families. **Qwen3-8B** (8.2B parameters, text-only, 32K native context)   and the newer **Qwen3.5-9B** (9B parameters, multimodal text+image, 256K context).  Both run well on 24GB.

```bash
# Pull the models:
ollama pull qwen3:8b          # 5.2GB, Q4_K_M, text-only
ollama pull qwen3.5:9b        # 6.6GB, Q4_K_M, multimodal

# For specific quantizations:
ollama pull qwen3:8b-q8_0     # 8.9GB, near-lossless
# Or from HuggingFace:
ollama run hf.co/Qwen/Qwen3-8B-GGUF:Q5_K_M
```

**Thinking mode is the single biggest speed variable.** Qwen3 models support a “thinking” mode that generates chain-of-thought reasoning in `<think>` blocks before answering.  This produces dramatically more tokens — a response that would be 200 tokens in direct mode might generate 1,500+ tokens with thinking enabled. For speed-sensitive workloads, always disable it:

```bash
# In interactive mode:
/set nothink

# From command line:
ollama run qwen3:8b --think=false "your prompt"

# In API calls:
curl http://localhost:11434/api/chat -d '{
  "model": "qwen3:8b",
  "think": false,
  "messages": [{"role": "user", "content": "your prompt"}]
}'
```

Note: Qwen3.5 small models (including 9B) have **thinking disabled by default**,  so no action needed unless you explicitly enable it.

### Optimized Modelfile for Qwen3 on M4 24GB

```dockerfile
FROM qwen3:8b

# Qwen-recommended sampling parameters (non-thinking mode)
PARAMETER temperature 0.7
PARAMETER top_p 0.8
PARAMETER top_k 20

# Suppress repetition in quantized models (Qwen official recommendation)
PARAMETER repeat_penalty 1.5

# Performance settings
PARAMETER num_ctx 8192
PARAMETER num_gpu 999
PARAMETER num_predict -1

SYSTEM """You are a helpful assistant. /no_think"""
```

```bash
ollama create qwen3-fast -f Modelfile
ollama run qwen3-fast
```

The **`repeat_penalty 1.5`** is specifically recommended by Qwen’s official documentation for quantized models to suppress repetitive output.   The `num_gpu 999` ensures all layers are offloaded to Metal — do not set a lower value, as a known Ollama v0.12.x regression showed restrictive values can force CPU fallback. 

-----

## Memory management on Apple Silicon unified memory

The M4’s unified memory means CPU and GPU share the same 24GB pool, but macOS enforces a hard cap: **on systems with ≤36GB, the GPU gets roughly 66% (~16GB)**.  For an 8B Q4 model at 5.2GB, this cap is irrelevant. For larger models pushing the limit, you can override it:

```bash
# Raise GPU memory limit to 20GB (use cautiously):
sudo sysctl iogpu.wired_limit_mb=20480

# Verify:
sysctl iogpu.wired_limit_mb

# Check current memory pressure:
memory_pressure
# Or: Activity Monitor → Memory tab (green = good, red = swapping)

# Check swap usage:
sysctl vm.swapusage
```

**Do not disable swap.** macOS depends on it for stability, and disabling it risks kernel panics. Instead, ensure your model fits within physical RAM. If Activity Monitor shows red memory pressure during inference, use a smaller model or lower quantization rather than fighting the OS.  

Key memory management practices for 24GB:

Close memory-hungry applications before inference — a browser with a dozen tabs can consume 4–8GB alone.   Set `OLLAMA_MAX_LOADED_MODELS=1` to prevent accidentally loading multiple models. Use `ollama stop <model>` to explicitly free memory when switching models. Keep context length at 8K–16K unless you specifically need more; each doubling roughly doubles KV cache memory.  

-----

## System-level tuning for sustained inference

The Mac mini M4 has an active fan and runs on AC power, so thermal throttling and power management are less problematic than on MacBooks. Still, a few tweaks help:

```bash
# Prevent sleep during long inference sessions:
caffeinate -i -s &    # Runs in background; kill with: kill %1

# Disable display sleep for headless/server use:
sudo pmset -a displaysleep 0
sudo pmset -a sleep 0

# Temporarily pause Spotlight indexing during heavy inference:
sudo mdutil -a -i off
# Re-enable when done:
sudo mdutil -a -i on

# Check if thermal throttling has occurred:
pmset -g thermlog
```

Disable **Low Power Mode** in System Settings → Battery — it reduces GPU clocks. Ensure good airflow around the Mac mini (don’t stack objects on top). Under sustained LLM inference, the M4 Mac mini typically draws **19–25W**  and stays well within thermal limits.  Temperature-induced throttling is rare for inference workloads because they’re bandwidth-bound rather than compute-bound, generating less heat than all-core CPU stress tests. 

For production/server use, store models on the internal SSD (not external drives) for fastest loading.  You can change the model directory with `launchctl setenv OLLAMA_MODELS "/path/to/fast/ssd/models"`. 

-----

## Realistic benchmarks and what to expect

Based on community benchmarks and controlled testing, here’s what the **base M4 Mac mini (24GB, 120 GB/s bandwidth)** delivers:

|Model                  |Quant |Generation (t/s)|Prompt eval (t/s)|RAM used|
|-----------------------|------|----------------|-----------------|--------|
|Qwen3 8B / Llama 3.1 8B|Q4_K_M|**28–35**       |~700             |~5.2 GB |
|Qwen3 8B               |Q8_0  |**22–26**       |~550             |~8.9 GB |
|Qwen3 14B              |Q4_K_M|**15–18**       |~400             |~9.3 GB |
|Llama 3.2 3B           |Q4_K_M|**~55–70**      |~1,200           |~2.0 GB |
|Qwen3 32B              |Q4_K_M|**~8–10**       |~200             |~19 GB ⚠️|

The theoretical maximum is `bandwidth ÷ model_size`: 120 GB/s ÷ 4.6 GB ≈ 26 t/s for an 8B Q4 model. Real-world numbers often exceed this due to caching effects, batch processing optimizations, and GQA (grouped-query attention) reducing effective reads. The **28–35 t/s range is well above comfortable reading speed** (~5–7 t/s), making interactive chat feel snappy.  

For comparison, the **M4 Pro (273 GB/s)** hits ~42 t/s on the same 8B Q4 model — roughly 20–30% faster despite having identical RAM in the 24GB configuration.   If raw speed matters more than budget, the $400 premium for M4 Pro buys meaningful gains.  But the base M4 is more than adequate for single-user inference.

-----

## Conclusion

The optimal configuration for running Qwen3/3.5 models on a 24GB M4 Mac mini comes down to five high-impact actions: enable flash attention and Q8 KV cache quantization, use Q4_K_M or Q5_K_M quantization, ensure all layers offload to Metal GPU, disable thinking mode for speed-sensitive tasks, and close memory-hungry background applications.  These alone get you to **28–35 tokens/sec** with 8B-class models — no exotic tuning required.

The base M4’s 120 GB/s bandwidth is the hard ceiling.  No software optimization bypasses this physical constraint.   If you need more speed, the path is smaller models (3–4B at 55+ t/s), lower quantization, or upgrading to M4 Pro hardware. But for a **$599–$799 machine running 8–14B models locally with zero cloud costs**, the M4 Mac mini delivers remarkable performance per dollar — rivaling what required a $700+ discrete GPU just two years ago. 
