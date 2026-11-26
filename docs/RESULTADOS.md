# Resultados locais

Medições de 25/11/2026: Intel Core i7-9700, NVIDIA RTX 3060 12 GB,
32 GB de RAM e Windows 10 19045. Outros aplicativos permaneceram abertos.

## Janelas de argumentos indiretos

Mesma execução, câmera parada na cela, perfil visual original, sem profiler
ou compilação externa em paralelo. Cada trecho de desempenho durou 60 segundos.
Tempos obtidos pela diferença entre registros consecutivos de `Present`.
Não são durações exclusivas da GPU nem medidas de scanout.

| Configuração | Mediana | p95 | FPS equivalente à mediana |
|---|---:|---:|---:|
| Original A1 | 475,058 ms | 634,697 ms | 2,11 |
| Janelas ligadas, validação desligada | 415,759 ms | 547,908 ms | 2,41 |
| Original A2 | 472,731 ms | 619,796 ms | 2,12 |

Contra a média das medianas originais: aproximadamente 12% menos tempo e
14% mais FPS equivalente. Validação separada: 120.119 registros comparados,
zero divergências no trecho. Isso não prova corretude em outras cenas.

## Memória e readback

Janelas ligadas em todos os trechos, 60 segundos por trecho:

| Configuração | Mediana | p95 |
|---|---:|---:|
| Referência A1 | 512,032 ms | 694,796 ms |
| Orçamento de reconciliação ampliado para 8.192 | 464,519 ms | 648,730 ms |
| Referência A2 | 432,073 ms | 539,829 ms |
| Cópias contíguas de readback agrupadas | 429,470 ms | 558,218 ms |
| Referência A3 | 423,840 ms | 541,673 ms |

Sem ganho adicional demonstrado: a referência também melhorou ao longo da
execução. Novas opções permanecem desligadas por padrão. A união reduziu,
em um intervalo, 3.814 regiões para 439, com os mesmos 246.211.016 bytes.
Os testes unitários de equivalência e fronteiras passaram.

## Limites

- Artefatos visuais e desenhos descartados por pipelines indisponíveis continuam.
- Não houve validação visual pixel a pixel.
- Tempos de preparação, readback e espera podem se sobrepor; não devem ser somados.
- A pressão de RAM e a instrumentação interferiram em outras coletas.
- O ganho das janelas foi observado nesta execução, não em todo o jogo.
- Não há promessa de 30 FPS, estabilidade prolongada ou compatibilidade universal.

Capturas, logs brutos, saves, shaders e recursos do jogo não são distribuídos.
