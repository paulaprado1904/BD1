/* Paula Prado Carvalho
 * 12211BSI267
 * */


SET search_path TO locadora;

/* QUESTÃO 1 */
SELECT c.* FROM cliente c WHERE c.foneres LIKE ('(21)%') OR c.fonecel LIKE ('(21)%')

/* QUESTÃO 2 */
SELECT e.* FROM emprestimo e WHERE e.dataret BETWEEN '2013-01-01' AND '2013-06-30' ORDER BY e.dataret desc

/* QUESTÃO 3 */
 SELECT c.* FROM cliente c WHERE length(c.nome) > 15
 
/* QUESTÃO 4 */
SELECT a.nomereal AS nome FROM ator a 
UNION
SELECT f.direcao AS nome FROM filme f 
UNION
SELECT c.nome AS nome FROM cliente c 

/* QUESTÃO 5 */
SELECT * FROM emprestimo e WHERE (e.datadev - e.dataret) > 7

/* QUESTÃO 6 */
SELECT * FROM filme f WHERE f.duracao > 120 AND (f.categoria LIKE '%Aventura%' OR f.categoria LIKE '%Drama%')

/* QUESTÃO 7 */
SELECT * FROM filme f ORDER BY f.data_lancamento ASC LIMIT 5

/* QUESTÃO 8 */
SELECT min(e.valor_pg) FROM emprestimo e 

/* QUESTÃO 9 */
SELECT count(*) FROM emprestimo e WHERE e.dataret::varchar(12) LIKE '2013%' 

/* QUESTÃO 10 */
SELECT avg(e.datadev - e.dataret) FROM emprestimo e  
