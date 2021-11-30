---
class: left, top
background-image: url(img/ggplot2.png)
background-position: 95% 8%
background-size: 6%

# .red[Category:] .fancy[Plot]

.panelset[

.panel[.panel-name[Info].large[

*Description*

]]

.panel[.panel-name[Data].code60[

```{r geom_1_data}
penguins <- palmerpenguins::penguins
```

]]

.panel[.panel-name[R Code].code60[

```{r geom_1, fig.show='hide'}
penguins %>% 
    ggplot(aes(x = flipper_length_mm)) + 
    geom_histogram()
```

]]

.panel[.panel-name[Plot].border[

```{r plot-geom_1, ref.label='geom_1', echo=FALSE, fig.align='center', out.width='55%', out.height='55%'}
```

]]]