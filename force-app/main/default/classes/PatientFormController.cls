public with sharing class PatientFormController {
    @AuraEnabled
    public static void savePatient(String patientName, Integer age, String sex, String phone, String issue) {
        try {
            Patient__c patient = new Patient__c(
                Patient_Name__c = patientName,
                Age__c = age,
                Sex__c = sex,
                Phone__c = phone,
                Issue__c = issue
            );
            insert patient;
        } catch (Exception e) {
            throw new AuraHandledException('Error saving patient: ' + e.getMessage());
        }
    }
}
