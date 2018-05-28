public class StellaxiusTeamComponentController {
	public StellaxiusTeamComponentController() {
	}

	/**
		Get the List of Team Members that are published to the WebSite.

	*/
    public List<Employee__c> publishedTeamMembers {
		get {
			return [
				SELECT
					Id,
					Name,
					Role__c,
					Bio__c,
					User_Name__c
				FROM
					Employee__c
				WHERE
					Publish_On_Website__c = TRUE
				ORDER BY
					User_Name__c
			];
		}
    }

	/**
		The Site Prefix.

	*/
	public String siteBase {
		get {
			return StellaxiusSiteController.getSiteBase();
		}
	}

	/**

		Get the Site Prefix from current page URL.

	**/
	public static String getSiteBase() {
		return Site.getBaseUrl();
	}
}