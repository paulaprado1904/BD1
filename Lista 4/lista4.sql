/*Trabalho 4 – Banco de Dados I (GSI016)Prof: Wendel Melo - FACOM/UFU*/

/*Paula Prado Carvalho*/
/* 12211BSI267 */

SET SEARCH_PATH TO cargasaereas;

/* QUESTÃO 1 */
SELECT
	r.*
FROM
	rota r
INNER JOIN voo v ON
	v.codvoo = r.codvoo
INNER JOIN empresa e ON
	v.codemp = e.codemp
INNER JOIN trecho t ON
	t.origem = r.origem
	AND t.destino = r.destino
WHERE
	e.codemp = 'GLO'
ORDER BY
	r.h_saida ;

/* QUESTÃO 2 */
SELECT
	v.*,
	r.destino
FROM
	viagem v
INNER JOIN rota r ON
	r.codrota = v.codrota
WHERE
	r.origem = 'GIG'
	AND v."data" = '2022-11-07'
ORDER BY
	r.h_saida ;

/* QUESTÃO 3 */
SELECT
	DISTINCT r.origem
FROM
	rota r
INNER JOIN voo v ON
	r.codvoo = v.codvoo
INNER JOIN empresa e ON
	e.codemp = v.codemp
WHERE
	e.codemp = 'AZU'
UNION 
SELECT
	DISTINCT r.destino
FROM
	rota r
INNER JOIN voo v ON
	r.codvoo = v.codvoo
INNER JOIN empresa e ON
	e.codemp = v.codemp
WHERE
	e.codemp = 'AZU';

/* QUESTÃO 4 */
SELECT
	e.codemp , e.nome ,
	r.origem ,r.destino , v."data" ,v.h_saida_real , r.h_saida
	--, atraso.mediaAtraso
FROM
	viagem v
INNER JOIN rota r ON
	r.codrota = v.codrota
INNER JOIN voo v2 ON
	v2.codvoo = r.codvoo
INNER JOIN empresa e ON
	e.codemp = v2.codemp ,
(SELECT AVG(v.h_saida_real - r.h_saida) AS mediaAtraso
FROM rota r
INNER JOIN viagem v ON v.codrota = r.codrota
where (v.h_saida_real - r.h_saida) > INTERVAL '00:00:00'  ) atraso 
WHERE (v.h_saida_real - r.h_saida) > atraso.mediaAtraso ;

/* QUESTÃO 5 */

SELECT  x.codvoo, x.duracao
FROM (
    SELECT SUM(r.h_chegada - r.h_saida) AS duracao, r.codvoo
    FROM rota r
    GROUP BY r.codvoo
) AS x
WHERE x.duracao = (
    SELECT MAX(duracao)
    FROM (
        SELECT SUM(r.h_chegada - r.h_saida) AS duracao, r.codvoo
        FROM rota r
        GROUP BY r.codvoo
    ) AS maxima
);

/* QUESTÃO 6 */
SELECT e.codemp , v.codvoo , 
(SELECT origem FROM rota WHERE codvoo = v.codvoo AND h_saida = (SELECT min(h_saida) FROM rota WHERE codvoo = v.codvoo)), 
(SELECT min(h_saida) FROM rota WHERE codvoo = v.codvoo), 
(SELECT destino FROM rota WHERE codvoo = v.codvoo AND h_chegada = (SELECT max(h_chegada) FROM rota WHERE codvoo = v.codvoo)), 
(SELECT max(h_chegada) FROM rota WHERE codvoo = v.codvoo), 
(SELECT count(codrota) -1 /*deduz 1 viagem que não conta como escala */  FROM rota WHERE codvoo = v.codvoo) Escalas
FROM voo v INNER JOIN rota r ON v.codvoo = r.codvoo INNER JOIN empresa e ON e.codemp = v.codemp 
GROUP BY v.codvoo , e.codemp
ORDER BY v.codvoo;

/* QUESTÃO 7 */

SELECT v2.codemp, e.nome AS nome_empresa, r.codvoo, r.destino, v.h_saida_real 
FROM rota r
INNER JOIN viagem v ON r.codrota = v.codrota
INNER JOIN voo v2 ON v2.codvoo = r.codvoo
INNER JOIN empresa e ON e.codemp = v2.codemp
WHERE r.origem = 'GIG' AND v."data" = '2022-11-07' AND v.h_saida_real IN (SELECT min(h_saida_real)
																		  FROM viagem vi INNER JOIN rota ro ON ro.codrota = vi.codrota 
																		  INNER JOIN voo vo ON vo.codvoo = ro.codvoo WHERE vi."data" = '2022-11-07' AND ro.origem = 'GIG' GROUP BY vo.codemp )
GROUP BY v2.codemp, e.nome, r.codvoo, r.destino, v."data", v.codrota ;

/* QUESTÃO 8 */

SELECT v.*, r.codvoo, r.origem, r.destino, r.h_saida , r.h_chegada, 
CASE WHEN (v.h_saida_real - r.h_saida) > '00:10:00' THEN 'Atrasado'
	ELSE 'Pontual' END AS "Observação"
FROM viagem v INNER JOIN rota r ON v.codrota = r.codrota INNER JOIN voo v2 ON v2.codvoo = r.codvoo
WHERE v."data" = '2022-11-07' AND v2.codemp = 'AZU' ORDER BY "Observação";

/* QUESTÃO 9 */

SELECT e.codemp , e.nome ,
       AVG((r2.h_saida - r1.h_chegada)) 
FROM empresa e
JOIN voo v ON e.codemp = v.codemp
JOIN rota r1 ON v.codvoo = r1.codvoo
JOIN rota r2 ON r1.codvoo = r2.codvoo AND r1.codrota < r2.codrota
WHERE (SELECT count(codrota) FROM rota WHERE codvoo = v.codvoo) > 1 /*INDICA QUE TEM ESCALA*/
GROUP BY e.nome, e.codemp ;

/* QUESTÃO 10 */

SELECT  v.codvoo, v.codemp, min(v2."data") , (SELECT origem FROM rota WHERE codrota = (SELECT min(codrota) FROM rota WHERE codvoo = v.codvoo)), 
(SELECT destino FROM rota WHERE codrota = (SELECT max(codrota) FROM rota WHERE codvoo = v.codvoo)), 
(SELECT h_saida_real FROM viagem WHERE codrota = 
			(SELECT min(codrota) FROM rota WHERE codvoo = v.codvoo) AND "data" = '2022-11-07 00:00:00.000'),
(SELECT h_chegada_real FROM viagem WHERE codrota = 
			(SELECT max(codrota) FROM rota WHERE codvoo = v.codvoo) AND "data" = '2022-11-07 00:00:00.000')
FROM  voo v 
JOIN rota r1 ON v.codvoo = r1.codvoo
JOIN rota r2 ON r1.codvoo = r2.codvoo AND r1.codrota < r2.codrota
JOIN viagem v2 ON v2.codrota = r1.codrota
WHERE (r1.origem = 'BHZ' AND r2.destino = 'POA') AND v.codemp = 'GLO' AND v2."data" = '2022-11-07 00:00:00.000'
GROUP BY v.codvoo, v.codemp;


/* QUESTÃO 11 */

SELECT DISTINCT e.codemp , e.nome , v.codvoo  
FROM voo v INNER JOIN empresa e ON e.codemp = v.codemp INNER JOIN rota r ON r.codvoo = v.codvoo 
WHERE v.codvoo NOT IN (SELECT codvoo FROM rota WHERE origem = 'POA' OR destino = 'POA')
ORDER BY 1;

/* QUESTÃO 12 */
/*
SELECT count(v.*), v.codemp  FROM voo v LEFT JOIN rota r  ON v.codvoo = r.codvoo WHERE r.codvoo IN (SELECT codvoo FROM rota WHERE origem = 'GIG' OR destino = 'GIG')GROUP BY v.codemp; 		/* quantidade de voos que passam por GIG */
SELECT count(v.*), v.codemp  FROM voo v LEFT JOIN rota r  ON v.codvoo = r.codvoo GROUP BY v.codemp; 		/* quantidade de voos totais para poder comparar */
*/
SELECT voosGIG.codemp , e.nome 
		FROM (SELECT count(v.*) qtd, v.codemp  FROM voo v LEFT JOIN rota r  ON v.codvoo = r.codvoo WHERE r.codvoo IN (SELECT codvoo FROM rota WHERE origem = 'GIG' OR destino = 'GIG')GROUP BY v.codemp) voosGIG, 
			(SELECT count(v.*) qtd, v.codemp  FROM voo v LEFT JOIN rota r  ON v.codvoo = r.codvoo GROUP BY v.codemp) voosTotais,
			empresa e
		WHERE voosTotais.codemp = e.codemp AND voosGIG.codemp = e.codemp AND voosTotais.qtd = voosGIG.qtd
	ORDER BY 1;

/* QUESTÃO 13 */
	
SELECT codemp, nome from 
(SELECT DISTINCT r.origem, e.nome, e.codemp FROM rota r INNER JOIN voo v ON r.codvoo = v.codvoo INNER JOIN empresa e ON e.codemp = v.codemp
UNION 
SELECT DISTINCT r.destino, e.nome, e.codemp FROM rota r INNER JOIN voo v ON r.codvoo = v.codvoo INNER JOIN empresa e ON e.codemp = v.codemp) x 
GROUP BY nome,codemp 
HAVING count(DISTINCT origem) = (SELECT count(DISTINCT origem) FROM (SELECT r.origem  FROM rota r INNER JOIN voo v ON v.codvoo = r.codvoo INNER JOIN empresa e ON e.codemp = v.codemp 
									union
								 SELECT r.destino  FROM rota r INNER JOIN voo v ON v.codvoo = r.codvoo INNER JOIN empresa e ON e.codemp = v.codemp ) AS listaDeAeroportos
								); /*lista de aeroportos, caso aumente em algum momento*/

/* QUESTÃO 14 */

SELECT e.nome, v.codvoo, r.h_saida , r2.h_chegada, (SELECT origem FROM rota WHERE codvoo = v.codvoo AND origem <> r.origem AND destino <> r2.destino) AS "Escala 1",
(SELECT destino FROM rota WHERE codvoo = v.codvoo AND origem <> r.origem AND destino <> r2.destino) AS "Escala 2"
FROM empresa e INNER JOIN voo v ON v.codemp = e.codemp 
INNER JOIN rota r ON r.codvoo = v.codvoo 
INNER JOIN rota r2 ON r.codvoo = r2.codvoo AND r.codrota < r2.codrota
WHERE r.origem = 'BHZ'
AND r2.destino = 'POA'
AND (SELECT count(codrota) FROM rota WHERE codvoo = v.codvoo) <= 3; /* Podem ter 3 rotas , sendo uma normal e 2 como escala*/

/* QUESTÃO 15 */

/* Para o trecho A → B:
LEAST(Origem, Destino) retorna "A".
GREATEST(Origem, Destino) retorna "B".
Para o trecho B → A:
LEAST(Origem, Destino) retorna "A".
GREATEST(Origem, Destino) retorna "B".
Portanto, quando comparamos os resultados dessas funções para os dois trechos, ambos têm os mesmos valores. 
Isso significa que ambos os pares A → B e B → A serão tratados como o mesmo par de pontos quando agrupados ou ordenados.

Essa abordagem garante que os inversos não apareçam juntos, pois eles são tratados como o mesmo par de pontos devido à 
aplicação das funções LEAST e GREATEST, garantindo assim que apenas um dos pares de trechos e seus inversos seja selecionado.*/
SELECT 
    LEAST(origem, destino) ,
    GREATEST(origem, destino) , distancia ,
    (1000 * distancia  / (SELECT MAX(DISTANCIA) FROM TRECHO)) AS pontos
FROM 
    Trecho
GROUP BY 
    LEAST(origem, destino), GREATEST(origem, destino), distancia 
ORDER BY 
    pontos;

/* QUESTÃO 16 */
   
SELECT v.codemp, e.nome, v.codvoo, r.origem FROM voo v INNER JOIN rota r ON r.codvoo = v.codvoo
INNER JOIN rota r2 ON r.codvoo = r2.codvoo and r.codrota < r2.codrota 
INNER JOIN empresa e ON e.codemp = v.codemp
WHERE r.origem = r2.destino;