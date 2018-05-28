public class StellaxiusSiteController {
    private static Map<String,Website_Table__c> staticContactMap = getContactMap();
    private static Map<String,Job__c> staticJobMap = getJobMap();
    
    /**
List of Value, Description to populate the "Our Mission" table.

*/
    public List<Website_Table__c> ourMission {
        get {
            return getTableRecords('Mission');
        }
    }
    
    /**
List encoded as JSON for "Our Mission" table, used from JavaScript.

*/
    public String ourMissionJSON {
        get {
            return String.escapeSingleQuotes(JSON.serialize(ourMission));
        } 
    }
    
    /**
List of Value, Description to populate the "Our Values" table.

*/
    public List<Website_Table__c> ourValues {
        get {
            return getTableRecords('Values');
        }
    }
    
    
    /**
List encoded as JSON for "Our Values" table, used from JavaScript.

*/
    public String ourValuesJSON {
        get {
            return String.escapeSingleQuotes(JSON.serialize(ourValues));
        }
    }
    
    /**
List of Value, Description to populate the "Services" table.

*/
    public List<Website_Table__c> services {
        get {
            return getTableRecords('services');
        }
    }
    
    public String contactHeader {
        get {
            Website_Table__c header = staticContactMap.get('header');
            
            if (header != null) {
                return header.Description__c;
            } else {
                return null;
            }
        }
    }
    
    public String contactEmail {
        get {
            Website_Table__c email = staticContactMap.get('email');
            
            if (email != null) {
                return email.Description__c;
            } else {
                return null;
            }
        }
    }
    
    public String contactPhone {
        get {
            Website_Table__c phone = staticContactMap.get('phone');
            
            if (phone != null) {
                return phone.Description__c;
            } else {
                return null;
            }
        }
    }
    
    public String contactAddress {
        get {
            Website_Table__c address = staticContactMap.get('address');
            
            if (address != null) {
                return address.Description__c;
            } else {
                return null;
            }
        }
    }
    
    public String contactMap {
        get {
            Website_Table__c mapRecord = staticContactMap.get('map');
            
            if (mapRecord != null) {
                return mapRecord.Description__c;
            } else {
                return null;
            }
        }
    }
    
    /**

Get the Available Jobs.

*/
    public List<Job__c> jobs {
        get {
            return getJobRecords();
        }
    }
    
    public static Job__c getJobByReference(String jobReference) {
        return staticJobMap.get(jobReference);
    }
    
    public static String getJobByReferenceJSON(String jobReference) {
        return String.escapeSingleQuotes(JSON.serialize(getJobByReference(jobReference)));
    }
    
    /**
Constructor

**/
    
    public StellaxiusSiteController() {
    }
    
    @TestVisible private static List<Website_Table__c> getTableRecords(String tableName) {
        return [
            SELECT
            Id,
            Name,
            Table__c,
            Display_Order__c,
            Value__c,
            Description__c,
            Icon_Class__c
            FROM
            Website_Table__c
            WHERE
            Table__c = :tableName
            ORDER BY
            Display_Order__c
        ];
    }
    
    @TestVisible private static Map<String,Website_Table__c> getContactMap() {
        Map<String,Website_Table__c> resultMap = new Map<String,Website_Table__c>();
        
        List<Website_Table__c> contactRecords = getTableRecords('Contact');
        
        for (Website_Table__c contact : contactRecords) {
            resultMap.put(contact.Value__c, contact);
        }
        
        return resultMap;
    }
    
    @TestVisible private static List<Job__c> getJobRecords() {
        return [
            SELECT
            Id,
            Name,
            Custom_Job_Title__c,
            Icon_Class__c,
            Job_Position__c,
            Job_Specification__c,
            Job_Title__c,
            Is_Active__c,
            Sort_Order__c
            FROM
            Job__c
            WHERE
            Is_Active__c = TRUE
            ORDER BY
            Sort_Order__c
        ];
    }
    
    @TestVisible private static Map<String,Job__c> getJobMap() {
        Map<String,Job__c> jobMap = new Map<String,Job__c>();
        
        List<Job__c> jobRecords = getJobRecords();
        
        for (Job__c job : jobRecords) {
            jobMap.put(job.Name, job);
        }
        
        return jobMap;
    }
    
    /**
Is this site in Production ?

**/
    public Boolean isProduction {
        get {
            Organization org = [SELECT IsSandbox FROM Organization LIMIT 1];
            
            return (org.isSandbox == false);
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