public with sharing class StellaxiusTestimonialComponentController {
    public StellaxiusTestimonialComponentController() { 
    }

    /**
        Get the List of Testimonials that are published to the WebSite.

    */
    public List<Testimonial__c> publishedTestimonials {
        get {
            return [
                SELECT
                    Id,
                    Name,
                    Role__c,
                    Testimonial_Text__c,
                    Photo_Resource__c
                FROM
                    Testimonial__c
                WHERE
                    Publish_On_Website__c = TRUE
                ORDER BY
                    Name
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