---
layout: single
title: "Spark - Java / Maven (Iceberg)"
categories: spark
tag: [java, maven, session, iceberg, create, select, insert, upsert]
toc: true
toc_sticky: true
#author_profile: false

---



### 1. Maven Project Setup

```xml
<dependencies>
    <!-- Spark Core -->
    <dependency>
        <groupId>org.apache.spark</groupId>
        <artifactId>spark-core_2.12</artifactId>
        <version>3.3.1</version>
    </dependency>

    <!-- Spark SQL -->
    <dependency>
        <groupId>org.apache.spark</groupId>
        <artifactId>spark-sql_2.12</artifactId>
        <version>3.3.1</version>
    </dependency>

    <!-- Iceberg Spark Runtime -->
    <dependency>
        <groupId>org.apache.iceberg</groupId>
        <artifactId>iceberg-spark-runtime-3.3_2.12</artifactId>
        <version>1.2.0</version>
    </dependency>
</dependencies>
```

### 2. Configuring Spark Session & Operations

```text
In this setup:

args[2] is "C" - specifies the create script and partition colunm(e.g., "id INT, name STRING, value DOUBLE". "name").
args[2] is "S" - is for the select condition ("id = 123")
args[2] is "U" - provides the sourceData. (tuple like, "123, 'New Name', 45.6")
args[2] is "D" - specifies the delete condition. ("id = 123")
```



```java
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;

public static void main(String[] args) {
    SparkSession spark = SparkSession.builder()
            .appName("IcebergSparkApp")
            .config("spark.sql.catalog.my_catalog", "org.apache.iceberg.spark.SparkCatalog")
            .config("spark.sql.catalog.my_catalog.type", "hadoop")
            .config("spark.sql.catalog.my_catalog.warehouse", "path/to/your/warehouse")
            .getOrCreate();

    case args[2] {
        "C":
            // Create Table with Merge-on-Read Enabled
            TableCreation.createTable(spark, "my_catalog.my_table", args[3], args[4]);
			break;
        "S":
            // Select, Upsert, and Delete Examples
            Dataset<Row> result = SelectOperation.performSelect(spark, "my_catalog.my_table", args[3]);
            result.show();
			break;
        "U":
            UpsertOperation.performUpsert(spark, "my_catalog.my_table", args[3]);
            break;
        "D":
            DeleteOperation.performDelete(spark, "my_catalog.my_table", args[3]);
            break;
        default:
    }

    spark.stop();
}

public class TableCreation {
    public static void createTable(SparkSession spark, String tableName, String schema, String partitionColumn) {
        String createTableQuery = String.format(
            "CREATE TABLE IF NOT EXISTS %s (%s) " +
            "USING iceberg " +
            "PARTITIONED BY (%s) " +
            "TBLPROPERTIES ('write.delete.mode'='merge-on-read')", 
            tableName, schema, partitionColumn
        );
        
        spark.sql(createTableQuery);
    }
}

public class SelectOperation {
    public static Dataset<Row> performSelect(SparkSession spark, String tableName, String condition) {
        String query = String.format("SELECT * FROM %s WHERE %s", tableName, condition);
        return spark.sql(query);
    }
}

public class UpsertOperation {
    public static void performUpsert(SparkSession spark, String tableName, String sourceData) {
        String upsertQuery = String.format(
                "MERGE INTO %s t USING (SELECT * FROM VALUES (%s) AS s(id, name, value)) " +
                "ON t.id = s.id " +
                "WHEN MATCHED THEN UPDATE SET t.name = s.name, t.value = s.value " +
                "WHEN NOT MATCHED THEN INSERT (id, name, value) VALUES (s.id, s.name, s.value)", 
                tableName, sourceData);

        spark.sql(upsertQuery);
    }
}

public class DeleteOperation {
    public static void performDelete(SparkSession spark, String tableName, String condition) {
        String deleteQuery = String.format("DELETE FROM %s WHERE %s", tableName, condition);
        spark.sql(deleteQuery);
    }
}

```

