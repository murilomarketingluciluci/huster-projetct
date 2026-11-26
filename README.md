# Huster Project

**Um laboratório de renderização e desempenho D3D12 para Windows.**

![Status: experimental](https://img.shields.io/badge/status-experimental-orange)
![Licença: GPL-3.0](https://img.shields.io/badge/licença-GPL--3.0-blue)
![Plataforma: Windows x64](https://img.shields.io/badge/plataforma-Windows_x64-0078D4)

Fork de VIctory dedicado a investigar gargalos de preparação de comandos,
coerência de memória e sincronização CPU/GPU, preservando uma referência visual
funcional. O nome deste repositório é **huster-projetct**.

> Apenas código, documentação e testes. **Nenhum arquivo de jogo, shader extraído,
> save, cache, executável do jogo ou recurso proprietário é distribuído aqui.**

## O que já conseguimos

- Renderização do cenário na máquina de referência, com limitações visuais.
- Janelas de preparação de argumentos indiretos ativadas no launcher recomendado.
- Aproximadamente **12% menos tempo por quadro** em um A/B local: de cerca de
  474 ms para 416 ms. Isso corresponde a aproximadamente **2,1 para 2,4 FPS**,
  não a uma experiência fluida.
- 120.119 registros indiretos comparados, sem divergência no trecho testado.
- Controles independentes para experimentos, métricas e investigação de fences.

Os resultados são de uma cena em uma máquina. Não prometemos 30 FPS nem
estabilidade universal. [Veja metodologia e resultados completos](docs/RESULTADOS.md).

## Máquina de referência

| Componente | Configuração |
|---|---|
| CPU | Intel Core i7-9700 |
| GPU | NVIDIA GeForce RTX 3060, 12 GB |
| RAM | 32 GB |
| Sistema | Windows 10, build 19045 |
| Backend | Direct3D 12 |

## Compilar

Requisitos: Windows x64, CPU com AVX2, GPU D3D12 com os recursos exigidos pela
base, Rust conforme `rust-toolchain.toml` e ferramentas MSVC/Windows SDK.

```powershell
git clone https://github.com/murilomarketingluciluci/huster-projetct.git
cd huster-projetct
cargo build --locked --release -p victory --features diagnostics,blake3/pure
```

O executável ainda se chama `victory.exe`, para manter compatibilidade com o
workspace herdado. O código inclui exportações para **Agility SDK 1.620.2**
(`D3D12SDKVersion=620`). Obtenha o runtime no pacote oficial
[Microsoft.Direct3D.D3D12](https://www.nuget.org/packages/Microsoft.Direct3D.D3D12/1.620.2)
e coloque `D3D12Core.dll` em `target/release/D3D12/`. Para usar a camada de
validação, o runtime de depuração correspondente também é necessário.
DLLs não são incluídas no repositório.

## Executar

Forneça seus próprios arquivos legalmente obtidos. Mantenha-os fora do repositório.

```powershell
.\scripts\Iniciar-Huster.ps1 -Exe 'D:\MeusArquivos\executavel-do-titulo.exe'
```

O launcher usa `%LOCALAPPDATA%\huster-projetct\cache` e
`%LOCALAPPDATA%\huster-projetct\data`. Ele preserva os caminhos `VICTORY_*`
explicitamente definidos pelo usuário e limpa outras flags herdadas de testes.
Não importa automaticamente saves ou configurações de outras instalações.

`VICTORY_WINDOW_MAX=1280x720` limita a janela; **não garante resolução interna
menor**. A iluminação ray traced da base permanece incompleta; use os resultados
visuais como referência experimental, não como reprodução fiel de um console.

## Experimentos disponíveis

| Opção | Função | Padrão do launcher |
|---|---|---|
| `VICTORY_INDIRECT_WINDOW` | Reaproveita preparação de argumentos indiretos | `1` |
| `VICTORY_INDIRECT_WINDOW_CHECK` | Compara registros com preparação nova; adiciona custo | `0` |
| `VICTORY_MERGE_BUDGET_EXTENDED` | Eleva o orçamento de reconciliação para 8.192 trechos | desligada |
| `VICTORY_READBACK_COALESCE` | Junta cópias contíguas do mesmo recurso no readback direct | desligada |
| `VICTORY_FENCE_TRACE` | Registra esperas de CPU com identificação de fence | desligada |
| `VICTORY_PROFILE` | Profiler de amostragem; pode interferir na execução | desligada |

Para testar flags manualmente, invoque o binário diretamente; o launcher limpa
experimentos herdados para manter sua referência conhecida. Comentários no código
descrevem os controles por arquivo e demais opções.

## Validar

```powershell
cargo xtask policy
cargo test --locked --release -p victory-gpu --features diagnostics,blake3/pure readback_coalesce
```

A política impede a inclusão acidental de recursos do jogo. Alguns testes gráficos
exigem uma GPU e recursos D3D12 compatíveis. A compilação não equivale a validação
visual ou de segurança.

## Limitações conhecidas

- FPS baixo, pressão de RAM/VRAM e compilação inicial demorada.
- Pipelines indisponíveis podem descartar desenhos e deixar partes do 3D ausentes.
- Artefatos visuais e iluminação incompleta ainda existem.
- Agrupar cópias de readback reduziu comandos, mas não demonstrou ganho de FPS.
- O orçamento maior de reconciliação não teve ganho confirmado; continua opcional.
- Caches de shader/pipeline dependem de versão, configurações e driver.

## Contribuir

Abra uma issue com GPU, driver, CPU, RAM, versão do Windows, commit e flags.
Ao relatar desempenho, informe cena, mediana/p95 e se havia compilação pendente.
Não envie dumps, shaders, saves, capturas de buffers nem outros arquivos do jogo.
Revise e remova dados pessoais de qualquer log antes de compartilhá-lo.

## Créditos e licença

Baseado em [VIctory](https://github.com/Marvisak/VIctory) e no trabalho de
[fxceless](https://github.com/fxceless/victory-fork), com origem e créditos documentados. [Origem e escopo das alterações](docs/ORIGEM.md).

**GPL-3.0**, conforme [LICENSE](LICENSE). Projeto independente, experimental e sem
vínculo com fabricantes de consoles, GPUs ou desenvolvedores dos títulos.

