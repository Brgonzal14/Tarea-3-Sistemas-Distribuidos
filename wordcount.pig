/* wordcount.pig */

-- 1. Carga los datos desde HDFS 
lines = LOAD '$INPUT' USING PigStorage('\n') AS (line:chararray);

-- 2. Tokenizar: Separa las líneas en palabras y aplana la lista
words = FOREACH lines GENERATE FLATTEN(TOKENIZE(line)) as word;

-- 3. Limpieza: Convierte a minúsculas y filtra los vacíos
clean_words_step1 = FOREACH words GENERATE LOWER(word) as word;
-- Filtramos palabras que sean solo signos o vacías (opcional pero recomendado)
clean_words = FILTER clean_words_step1 BY SIZE(word) > 1;

-- 4. Agrupa por palabra
grouped = GROUP clean_words BY word;

-- 5. Cuenta las ocurrencias
wordcount = FOREACH grouped GENERATE group, COUNT(clean_words) as count;

-- 6. Ordena por frecuencia (de mayor a menor) 
ordered_wordcount = ORDER wordcount BY count DESC;

-- 7. Guardar el resultado en HDFS 
STORE ordered_wordcount INTO '$OUTPUT' USING PigStorage(',');