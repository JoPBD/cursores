DO $$
DECLARE
	-- Declaração do cursor ( unbound(não vinculado))
	cur_delete REFCURSOR;
	tupla RECORD;
BEGIN
	--Abertura do cursor
	--Scrool para descer e subir
	
	OPEN cur_delete SCROLL FOR 
		SELECT * FROM tb_youtubers;
	LOOP 
		--Recuperação de dados 
		FETCH cur_delete INTO tupla;
		EXIT WHEN NOT FOUND;
		IF tupla.video_count IS NULL THEN
			DELETE FROM tb_youtubers WHERE CURRENT OF
			cur_delete;
		END IF;
	END LOOP;
	
	LOOP 
		FETCH BACKWARD FROM cur_delete INTO tupla;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE '%', tupla;
	END LOOP;
	
	-- Fechamento do cursor
	CLOSE cur_delete;
END;
$$

-- cursores com parâmetros
-- DO $$
-- DECLARE
-- 	v_ano INT := 2010;
-- 	v_inscritos INT := 60000000;
-- 	v_youtuber VARCHAR(200);
-- 	-- vinculado (bound)
-- 	--1 Declaração do cursor
-- 	cur_ano_inscritos CURSOR (ano INT, inscritos INT)
-- 	FOR SELECT youtuber FROM tb_youtubers WHERE 
-- 	started >= ano AND subscribers >= inscritos;
-- BEGIN
-- 	-- Passagem pela ordem
-- 	--OPEN cur_ano_inscritos(v_ano, v_inscritos);
-- 	-- Passagem por nome
-- 	--2 Abertura
-- 	OPEN cur_ano_inscritos(inscritos := v_inscritos, ano := v_ano);
-- 	LOOP	
-- 		--3 Recuperação de dados
-- 		FETCH cur_ano_inscritos INTO v_youtuber;
-- 		EXIT WHEN NOT FOUND;
-- 		RAISE NOTICE '%', v_youtuber;
-- 	END LOOP;
-- 	-- Fechar o cursor 
-- 	CLOSE cur_ano_inscritos;
-- END;
-- $$

-- cursor unbound com query dinâmica
-- dinâmica: armazenada como stirng
-- exbir canais que começaram somente a partir
-- de um ano especifico

-- cursor vinculado (bound)
-- nome do youtuber e o número de inscritos
-- concatenando e exibindo apenas o final

-- DO $$
-- DECLARE
-- 	-- Declaração do cursor
-- 	cur_nomes_de_inscritos CURSOR FOR SELECT youtuber,
-- 	subscribers FROM tb_youtubers;
-- 	-- Um record pode representar uma linha
-- 	-- tupla.nome dá acesso ao valor na coluna nome
-- 	tupla RECORD;
-- 	resultado TEXT DEFAULT '';
-- BEGIN
-- 	-- Abrir o cursor
-- 	OPEN cur_nomes_de_inscritos;
-- 	FETCH cur_nomes_de_inscritos INTO tupla;
-- 	WHILE FOUND LOOP
-- 		resultado := resultado || tupla.youtuber || ':' || tupla.subscribers || ',';
-- 		--3 Recuperação dos dados
-- 		FETCH cur_nomes_de_inscritos INTO tupla;
-- 	END LOOP;
-- 	--4 Fechar o cursor
-- 	CLOSE cur_nomes_de_inscritos;
-- 	RAISE NOTICE '%', resultado;
-- END;	
-- $$

-- DO $$ 
-- DECLARE
-- 	-- Declarar o cursor
-- 	cur_nomes_a_partir_de REFCURSOR;
-- 	v_youtuber VARCHAR(200);
-- 	v_ano INT := 2008;
-- 	v_nome_tabela VARCHAR(200):= 'tb_youtubers';
-- BEGIN
-- 	--2 Abertura do cursor 
-- 	OPEN cur_nomes_a_partir_de FOR EXECUTE
-- 	format
-- 	(
-- 	'
-- 		SELECT youtuber FROM %s WHERE started >= $1	
-- 	',
-- 		v_nome_tabela
-- 	)USING v_ano;
-- 	LOOP
-- 		--3 Recuperação dos dados
-- 		FETCH cur_nomes_a_partir_de INTO v_youtuber;
-- 		EXIT WHEN NOT FOUND;
-- 		RAISE NOTICE '%', v_youtuber;
-- 	END LOOP;
-- 	--4 Fechar o cursor
-- 	CLOSE cur_nomes_a_partir_de;
-- END;
-- $$

-- DO $$
-- DECLARE
-- 	-- 1 Declaração do cursor
-- 	-- Não vinculado
-- 	cur_nomes_youtubers REFCURSOR;
-- 	-- Para armazenar o nome d vez
-- 	v_youtuber VARCHAR(200);
-- BEGIN
-- 	--2 Abertura do cursor 
-- 	OPEN cur_nomes_youtubers FOR 
-- 		SELECT youtuber 
-- 		FROM tb_youtubers;
	
-- 	LOOP 
-- 		--3 Recuperação dos dados de interesse
-- 		FETCH cur_nomes_youtubers INTO v_youtuber;
-- 		-- variável especial: FOUND
-- 		EXIT WHEN NOT FOUND;
-- 		RAISE NOTICE 'Nome: %', v_youtuber;
-- 	END LOOP;
-- 	--4 Fechar o cursor
-- 	CLOSE cur_nomes_youtubers;
-- END;
-- $$
-- SELECT * FROM tb_youtubers;

-- CREATE TABLE tb_youtubers(
-- 	cod_top_youtubers SERIAL PRIMARY KEY,
-- 	rank INT,
-- 	youtuber VARCHAR(200),
-- 	subscribers INT,
-- 	video_views VARCHAR(200),
-- 	video_count INT, 
-- 	category VARCHAR(200),
-- 	started INT
-- );