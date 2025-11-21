`README.md`.

-----

````markdown
# Tarea 3: Análisis Lingüístico Offline con Hadoop y Pig

Este proyecto implementa una solución de **Big Data** utilizando el ecosistema de **Apache Hadoop** para realizar un análisis comparativo de vocabulario entre respuestas humanas (Yahoo! Answers) y respuestas generadas por Inteligencia Artificial (LLM).

El sistema utiliza una arquitectura **Batch (Offline)** donde los datos son procesados mediante scripts de **Apache Pig**, ejecutando tareas de MapReduce simplificadas para tokenización, limpieza y conteo de frecuencia de palabras.

---

## 🏗️ Arquitectura del Sistema

El clúster está contenerizado con Docker y consta de los siguientes servicios:

| Servicio | Descripción |
| :--- | :--- |
| **Namenode** | Nodo maestro de Hadoop. Gestiona los metadatos del sistema de archivos distribuido (HDFS). |
| **Datanode** | Nodo esclavo que almacena los bloques de datos reales en HDFS. |
| **Pig-Client** | Contenedor cliente configurado con Apache Pig y Python. Desde aquí se inyectan los datos y se ejecutan los scripts de análisis (`.pig`). |

---

## 📂 Estructura del Proyecto

```text
TAREA_3_SISTEMAS_DISTRIBUIDOS/
├── docker-compose.yml    # Orquestación del clúster Hadoop
├── Dockerfile.pig        # Definición de la imagen del cliente Pig
├── hadoop.env            # Variables de entorno para configuración de Hadoop
├── wordcount.pig         # Script de análisis (Pig Latin) para conteo de palabras
├── yahoo_answers.txt     # Dataset: Respuestas humanas extraídas
├── llm_answers.txt       # Dataset: Respuestas generadas por IA
└── README.md             # Documentación del proyecto
````

-----

## 🚀 Instrucciones de Ejecución

### 1\. Levantar la Infraestructura

Asegúrate de tener Docker Desktop corriendo y ejecuta:

```bash
docker compose up -d --build
```

*Esto descargará las imágenes, construirá el cliente de Pig e iniciará el clúster.*

### 2\. Preparar HDFS (Ingesta de Datos)

Una vez que los contenedores estén activos ("Started"), crea el directorio de entrada en el sistema de archivos distribuido:

```bash
docker exec -it pig-client hdfs dfs -mkdir -p /input
```

Carga los archivos de texto al clúster:

```bash
# Subir dataset de Yahoo
docker exec -it pig-client hdfs dfs -put /app/yahoo_answers.txt /input/

# Subir dataset del LLM
docker exec -it pig-client hdfs dfs -put /app/llm_answers.txt /input/
```

*(Opcional) Verificar la carga:*

```bash
docker exec -it pig-client hdfs dfs -ls /input
```

### 3\. Ejecutar el Análisis (Pig Latin)

El script `wordcount.pig` realiza las siguientes operaciones de MapReduce:

1.  **Load:** Carga las líneas de texto.
2.  **Tokenize:** Divide el texto en palabras.
3.  **Clean:** Convierte a minúsculas y filtra signos.
4.  **Group & Count:** Agrupa por palabra y cuenta las ocurrencias.
5.  **Order:** Ordena por frecuencia descendente.
6.  **Store:** Guarda el resultado en HDFS.

Ejecuta el análisis para ambos conjuntos de datos:

**Para Yahoo Answers:**

```bash
docker exec -it pig-client pig -param INPUT=/input/yahoo_answers.txt -param OUTPUT=/output/yahoo_wc /app/wordcount.pig
```

**Para LLM Answers:**

```bash
docker exec -it pig-client pig -param INPUT=/input/llm_answers.txt -param OUTPUT=/output/llm_wc /app/wordcount.pig
```

-----

## 📊 Visualización de Resultados

Una vez finalizado el procesamiento, puedes consultar el **Top 10 de palabras más frecuentes** directamente desde la terminal.

**Resultados Yahoo (Humanos):**

```bash
# En PowerShell
docker exec -it pig-client hdfs dfs -cat /output/yahoo_wc/part-r-00000 | Select-Object -First 11

# En Linux/Mac/Bash
docker exec -it pig-client hdfs dfs -cat /output/yahoo_wc/part-r-00000 | head -n 11
```

**Resultados LLM (IA):**

```bash
# En PowerShell
docker exec -it pig-client hdfs dfs -cat /output/llm_wc/part-r-00000 | Select-Object -First 11

# En Linux/Mac/Bash
docker exec -it pig-client hdfs dfs -cat /output/llm_wc/part-r-00000 | head -n 11
```

-----

## ⏹️ Detener el Sistema

Para apagar el clúster y liberar recursos:

```bash
docker compose down
```

-----

### Autor

  * **Estudiante:** Bryan González
  * **Curso:** Sistemas Distribuidos 2025-2
  * **Universidad Diego Portales**

<!-- end list -->

```
```
