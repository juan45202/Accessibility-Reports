package test;

import com.deque.html.axecore.results.Results;
import com.deque.html.axecore.selenium.AxeBuilder;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import dataprovider.UrlDataProvider;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

public class AccessibilityTest {
	private WebDriver driver;
	private final String reportPath = System.getProperty("user.dir") + "\\target\\";
	private final String reportName = "accessibility_report";
	private final String accessibilityReport = reportPath + reportName;
	private final boolean isHeadless = true;

	@BeforeTest
	public void setUp() {
		ChromeOptions options = new ChromeOptions();
		options.addArguments("--headless", "--disable-gpu");

		if (isHeadless) {
			driver = new ChromeDriver(options);
		} else {
			driver = new ChromeDriver();
		}

		driver.manage().window().maximize();
		driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(30));
	}

	@AfterTest
	public void tearDown() {
		driver.quit();
	}

	@Test(dataProvider = "urlsProvider", dataProviderClass = UrlDataProvider.class)
	public void checkAccessibility(int index, String url) {
		driver.get(url);
		AxeBuilder axeBuilder = new AxeBuilder();
//		AxeBuilder axeBuilder = new AxeBuilder().withTags(Collections.singletonList("wcag22aa"));
//		AxeBuilder axeBuilder = new AxeBuilder().withTags(Arrays.asList("wcag21aa","best-practice"));
		Results results = axeBuilder.analyze(driver);

		if (results.violationFree()) {
			System.out.println("There are no accessibility violations in the URL: " + url);
		} else {
			String jsonResults = convertResultsToJson(results);
			String accessibilityReportName = accessibilityReport + "_url_" + index + ".html";
			generateHtmlReportWithFreemarker(jsonResults, accessibilityReportName);
		}
	}

	private String convertResultsToJson(Results results) {
		Gson gson = new Gson();
		try {
			return gson.toJson(results);
		} catch (Exception e) {
			System.err.println("Error converting results to JSON: " + e.getMessage());
			return null;
		}
	}

	private void generateHtmlReportWithFreemarker(String jsonResults, String filePath) {
		if (jsonResults == null) {
			System.err.println("The report could not be generated because the results are null.");
			return;
		}

		Configuration cfg = new Configuration(Configuration.VERSION_2_3_31);
		try {
			cfg.setDirectoryForTemplateLoading(new File("src/main/resources"));
			cfg.setDefaultEncoding("UTF-8");
			cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
			Template template = cfg.getTemplate("accessibility_report_template.ftl");
			ObjectMapper mapper = new ObjectMapper();
			Results results = mapper.readValue(jsonResults, Results.class);

			Map<String, Object> dataModel = new HashMap<>();
			dataModel.put("url", results.getUrl());
			dataModel.put("timestamp", results.getTimestamp());
			dataModel.put("passes", results.getPasses());
			dataModel.put("violations", results.getViolations());
			dataModel.put("incomplete", results.getIncomplete());
			dataModel.put("inapplicable", results.getInapplicable());

			try (Writer fileWriter = new FileWriter(filePath)) {
				template.process(dataModel, fileWriter);
			}

		} catch (IOException | TemplateException e) {
			System.err.println("Error saving the report: " + e.getMessage());
		}
	}
}