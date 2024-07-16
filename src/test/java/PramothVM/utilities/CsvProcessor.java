package custx.utilities;

import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;
import lombok.SneakyThrows;

import java.io.File;
import java.io.FileWriter;
import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class CsvProcessor {

    @SneakyThrows
    public static List<String[]> readFile(Path filePath) {
        try (Reader reader = Files.newBufferedReader(filePath)) {
            try (CSVReader csvReader = new CSVReader(reader)) {
                return csvReader.readAll();
            }
        }
    }

    @SneakyThrows
    public static File writeLineByLine(List<String[]> lines, String fileName) {
        File temp = File.createTempFile(fileName, ".csv");
        try (CSVWriter writer =
                     new CSVWriter(
                             new FileWriter(temp),
                             CSVWriter.DEFAULT_SEPARATOR,
                             CSVWriter.NO_QUOTE_CHARACTER,
                             CSVWriter.DEFAULT_ESCAPE_CHARACTER,
                             CSVWriter.DEFAULT_LINE_END)) {
            for (String[] line : lines) {
                writer.writeNext(line);
            }
        }
        temp.deleteOnExit();
        return temp;
    }

}
