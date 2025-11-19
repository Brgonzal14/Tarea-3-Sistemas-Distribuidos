/* wordcount.pig */

-- 1. Cargar los datos desde HDFS (El parámetro $INPUT se pasa al ejecutar)
lines = LOAD '$INPUT' USING PigStorage('\n') AS (line:chararray);

-- 2. Tokenizar: Separar las líneas en palabras y aplanar la lista
words = FOREACH lines GENERATE FLATTEN(TOKENIZE(line)) as word;

-- 3. Limpieza: Convertir a minúsculas y filtrar vacíos
clean_words_step1 = FOREACH words GENERATE LOWER(word) as word;
-- Filtramos palabras que sean solo signos o vacías (opcional pero recomendado)
clean_words = FILTER clean_words_step1 BY SIZE(word) > 1;

-- 4. Agrupar por palabra
grouped = GROUP clean_words BY word;

-- 5. Contar ocurrencias
wordcount = FOREACH grouped GENERATE group, COUNT(clean_words) as count;

-- 6. Ordenar por frecuencia (de mayor a menor) - Útil para el top 50
ordered_wordcount = ORDER wordcount BY count DESC;

-- 7. Guardar el resultado en HDFS (El parámetro $OUTPUT se pasa al ejecutar)
STORE ordered_wordcount INTO '$OUTPUT' USING PigStorage(',');