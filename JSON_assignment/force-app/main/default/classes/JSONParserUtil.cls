public class JSONParserUtil {
	public static boolean doesFieldExist(String objName, string fieldName) {
		try {
			SObject so = Schema.getGlobalDescribe().get(objName).newSObject();
			return so.getSobjectType().getDescribe().fields.getMap().containsKey(fieldName);
		} catch (Exception ex) {}

		return false;
	}
}