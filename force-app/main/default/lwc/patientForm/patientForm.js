import { LightningElement, track } from 'lwc';
import savePatient from '@salesforce/apex/PatientFormController.savePatient';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PatientForm extends LightningElement {
    @track patientName = '';
    @track age = '';
    @track sex = '';
    @track phone = '';
    @track issue = '';

    get sexOptions() {
        return [
            { label: 'Male', value: 'Male' },
            { label: 'Female', value: 'Female' },
            { label: 'Other', value: 'Other' }
        ];
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    handleSavePatient() {
        // Validate inputs
        if (!this.patientName || !this.age || !this.sex || !this.phone || !this.issue) {
            this.showToast('Error', 'Please fill all the fields.', 'error');
            return;
        }

        savePatient({
            patientName: this.patientName,
            age: parseInt(this.age),
            sex: this.sex,
            phone: this.phone,
            issue: this.issue
        })
        .then(() => {
            this.showToast('Success', 'Patient saved successfully!', 'success');
            this.clearFields();
        })
        .catch(error => {
            console.error('Error saving patient:', error);
            this.showToast('Error', error.body.message, 'error');
        });
    }

    clearFields() {
        this.patientName = '';
        this.age = '';
        this.sex = '';
        this.phone = '';
        this.issue = '';
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant
        }));
    }
}
