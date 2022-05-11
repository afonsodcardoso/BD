---a) Lista dos fornecedores que nunca tiveram encomendas;
SELECT * FROM gestStock.fornecedor EXCEPT SELECT nif,tempFornecedor.nome,fax,endereco,condpag,tipo 
FROM gestStock.fornecedor as tempFornecedor JOIN gestStock.encomenda as tempEncomenda ON tempFornecedor.nif=tempEncomenda.fornecedor;

---b) Número médio de unidades encomendadas para cada produto;
SELECT tempItem.codProd,avg(tempItem.unidades) as media_unidades_encomenda FROM gestStock.item as tempItem GROUP BY tempItem.codProd;
--SELECT * FROM gestStock.item as tempItem;

---c) Número médio de produtos por encomenda; (nota: não interessa o número de unidades);
SELECT avg(Cast(temp.produtos_encomenda as float)) as media_produtos_encomenda FROM ( SELECT count(tempItem.codProd) as produtos_encomenda FROM gestStock.item as tempItem GROUP BY tempItem.numEnc ) as temp

---d) Lista de produtos (e quantidades) fornecidas por cada fornecedor;
SELECT tempItem.codProd, tempEnc.fornecedor, sum(tempItem.unidades) as somatorio FROM gestStock.item as tempItem JOIN gestStock.encomenda as tempEnc ON tempItem.numEnc=tempEnc.numero
GROUP BY tempEnc.fornecedor,tempItem.codProd ORDER BY tempEnc.fornecedor