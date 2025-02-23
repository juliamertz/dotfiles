<script lang="ts">
  import { onMount } from "svelte";
  import * as zebar from "zebar";
  import type {
    BatteryOutput,
    CpuOutput,
    MemoryOutput,
    DateOutput,
    NetworkOutput,
    WeatherOutput
  } from "zebar";

  import "../app.css";

  let cpu = $state<CpuOutput | null>();
  let memory = $state<MemoryOutput | null>();
  let date = $state<DateOutput | null>();
  let network = $state<NetworkOutput | null>();
  let weather = $state<WeatherOutput | null>();

  onMount(() => {
    const providers = zebar.createProviderGroup({
      cpu: { type: "cpu" },
      memory: { type: "memory" },
      date: { type: "date", formatting: "yyyy/mm/dd HH:mm:ss" },
      network: { type: "network" },
      weather: { type: "weather" }
    });

    providers.onOutput(() => {
      cpu = providers.outputMap.cpu;
      memory = providers.outputMap.memory;
      date = providers.outputMap.date;
      network = providers.outputMap.network;
      weather = providers.outputMap.weather;
    });
  });

</script>

<div id="bar">
  <section class="left">
    workspaces
  </section>

  <section class="center">
    <span id="date">{date?.formatted}</span>
  </section>

  <section class="right">
    {#if cpu?.usage}
      <span>CPU: {Math.round(cpu.usage)}%</span>
    {/if}
    {#if memory?.usage}
      <span>MEM: {Math.round(memory.usage)}%</span>
    {/if}
  </section>
</div>
