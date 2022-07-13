import {api, LightningElement,wire, track} from 'lwc';
import generateReport from '@salesforce/apex/QSRReportsLwcController.GenerateReport';

export default class QSRReportsLWC extends LightningElement {

    //@api reportName;

    @track isModalOpen  = false;
    selectedReport = '';
    reportGenerationDate = Date.now();

    get reports() {
        return [
            { label: 'Marketing', value: 'Marketing' },
            { label: 'Marketing by Product Family', value: 'Marketing_PF' },
            { label: 'Sales', value: 'Sales' },
            { label: 'Sales by Product Family', value: 'Sales_PF' },
            { label: 'Bookings by Sales Person', value: 'Bookings_SP' },
            { label: 'PSG Bookings by Sales Person', value: 'PSG_Bookings_SP' },
            { label: 'Bookings by Product Family', value: 'Bookings_PF' }
        ];
    }

    openModal() {
        this.isModalOpen  = true;
        debugger;
    }

    closeModal() {
        this.isModalOpen  = false;
    }

    generateButtonClickHandler(component,  event, helper){

        const allValid = [...this.template.querySelectorAll('.myfield')]
        .reduce((validSoFar, inputCmp) => {
                    inputCmp.reportValidity();
                    return validSoFar && inputCmp.checkValidity();
        }, true);

        
        if (allValid) {
            generateReport({ reportName: this.selectedReport, generationDate: this.reportGenerationDate});
            alert('Your report will be ready in few minutes.\nTo see reports, go to "QSR Reports - Custom" reports folder.');
            this.isModalOpen  = false;
        } 

        
    }

    dateChangeHandler(event) {
        this.reportGenerationDate = event.target.value;
      }

    reportChangeHandler(event) {
        this.selectedReport = event.detail.value;
    }
}