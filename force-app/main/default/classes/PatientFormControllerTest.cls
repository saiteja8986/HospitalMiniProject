@IsTest
private class PatientFormControllerTest {
    @testSetup
    static void setupTestData() {
        // Create a test user with administrator privileges.
        Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User ownerUser = new User(
            Alias = 'stduser',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = standardUserProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com'
        );
        insert ownerUser;
    }

    @IsTest
    static void testSavePatient() {
        User testUser = [SELECT Id FROM User WHERE Alias = 'stduser'];

        System.runAs(testUser) {
            // Test saving a patient
            Test.startTest();
            PatientFormController.savePatient('John Doe', 30, 'Male', '1234567890', 'Fever');
            Test.stopTest();

            // Verify the patient was saved
            List<Patient__c> patients = [SELECT Id FROM Patient__c WHERE Patient_Name__c = 'John Doe'];
            System.assertEquals(1, patients.size(), 'Expected 1 patient record to be created');
        }
    }

    @IsTest
    static void testSavePatientWithException() {
        User testUser = [SELECT Id FROM User WHERE Alias = 'stduser'];

        System.runAs(testUser) {
            // Test saving a patient with an exception
            Test.startTest();
            try {
                PatientFormController.savePatient(null, 30, 'Male', '1234567890', 'Fever');
            } catch (Exception ex) {
                System.assert(ex.getMessage().contains('Error saving patient:'), 'Exception message does not match');
            }
            Test.stopTest();

            // Verify no patient records were created
            List<Patient__c> patients = [SELECT Id FROM Patient__c];
            System.assertEquals(0, patients.size(), 'Expected no patient records to be created');
        }
    }
}
