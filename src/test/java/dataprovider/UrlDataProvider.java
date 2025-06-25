package dataprovider;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.annotations.DataProvider;

import java.io.FileReader;
import java.io.IOException;

public class UrlDataProvider {

	@DataProvider(name = "urlsProvider")
	public Object[][] urlsProvider() throws IOException {
		FileReader reader = new FileReader("src/test/resources/urls.json");
		JSONTokener tokener = new JSONTokener(reader);
		JSONObject jsonObject = new JSONObject(tokener);
		JSONArray urlsArray = jsonObject.getJSONArray("urls");

		Object[][] data = new Object[urlsArray.length()][2];
		for (int i = 0; i < urlsArray.length(); i++) {
			data[i][0] = i + 1;
			data[i][1] = urlsArray.getString(i);
		}
		return data;
	}
}
