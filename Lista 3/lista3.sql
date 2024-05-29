/*Paula Prado Carvalho*/
/*12211BSI267*/

SET SEARCH_PATH TO locadora;

/* QUESTÃO 1 */
SELECT f.numfilme , f.titulo_original , f.titulo_pt , c.nome AS CLASSIFICACAO FROM filme f join classificacao c ON f.classificacao = c.cod  ;

/* QUESTÃO 2 */
SELECT count(c.*), c.nome  FROM filme f JOIN classificacao c ON f.classificacao = c.cod GROUP BY c.nome;

/* QUESTÃO 3 */
SELECT e.*, f.titulo_original  FROM emprestimo e JOIN filme f ON e.numfilme = f.numfilme;

/* QUESTÃO 4 */
SELECT DISTINCT f.direcao , a.nomereal  FROM filme f JOIN estrela e ON e.numfilme = f.numfilme JOIN ator a ON e.codator = a.cod ORDER BY 1;

/* QUESTÃO 5 */
SELECT e.cliente , avg(e.valor_pg)  FROM emprestimo e  GROUP BY e.cliente ORDER BY 1;

/* QUESTÃO 6 */
SELECT DISTINCT  c.nome AS cliente,  f.titulo_pt  FROM cliente c LEFT JOIN emprestimo e ON e.cliente = c.numcliente LEFT JOIN filme f ON e.numfilme = f.numfilme; 

/* QUESTÃO 7 */
SELECT DISTINCT  c.nome , a.nomeartistico FROM cliente c JOIN emprestimo e ON e.cliente = c.numcliente 
					  JOIN filme f ON e.numfilme = f.numfilme JOIN estrela es ON es.numfilme = f.numfilme 
					  JOIN ator a ON es.codator = a.cod 
	  WHERE a.nacionalidade IN ('USA', 'Canadá', 'México') ORDER BY 1;

/* QUESTÃO 8 */
SELECT c.nome, count(ind.*)  FROM cliente c LEFT JOIN cliente ind ON ind.numclienteindicador = c.numcliente GROUP BY c.numcliente

/* QUESTÃO 9 */
SELECT DISTINCT LEAST(a1.nomereal, a2.nomereal), GREATEST (a1.nomereal, a2.nomereal)
FROM filme f JOIN estrela e ON e.numfilme = f.numfilme JOIN ator a1 ON e.codator = a1.cod 
JOIN estrela e2 ON e2.numfilme  = f.numfilme JOIN ator a2 ON e2.codator = a2.cod --AND e.numfilme = e2.numfilme
WHERE a1.cod <> a2.cod;

/* QUESTÃO 10 */
SELECT DISTINCT LEAST(a1.nomereal, a2.nomereal), GREATEST (a1.nomereal, a2.nomereal), f.titulo_pt  
FROM filme f JOIN estrela e ON e.numfilme = f.numfilme JOIN ator a1 ON e.codator = a1.cod 
JOIN estrela e2 ON e2.numfilme  = f.numfilme JOIN ator a2 ON e2.codator = a2.cod --AND e.numfilme = e2.numfilme
WHERE a1.cod <> a2.cod;




SELECT e.* FROM emprestimo e
