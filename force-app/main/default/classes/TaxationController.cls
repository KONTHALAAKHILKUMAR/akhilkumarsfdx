public class TaxationController {
    
    public static Boolean firstPage = true;
    public Boolean editMode{get;set;}
    public DataMapper taxx{get;set;}

    /*public DataMapperNew taxx{
        get{
            if(this.taxx == null)
                this.taxx = new DataMapperNew();
            return this.taxx;
        }
        set;
    }*/
    public Attachment attachment {
    get {
        if (attachment == null)
            attachment = new Attachment();
        return attachment;
    }
    set;
    }

    public class AttachmentMeta{
        public String fileName{get;set;}
        public String fileValue{get;set;}
        public String fileId{get;set;}
        public AttachmentMeta(String a,String b,String c){
            this.fileName = a;
            this.fileValue = b;
            this.fileId = c;
        }
        public AttachmentMeta(){}
    }

    public Taxation__c tax;
    public String taxId{get;set;}
    public TaxationController getCont(){
        return this;
    }

    public Integer current{get;set;}
    public String first{get;set;}
    public String second{get;set;}
    public String third{get;set;}
    public String fourth{get;set;}
    public String fifth{get;set;}
    public String sixth{get;set;}
    public String seventh{get;set;}
    public Integer max{get;set;}

    public Boolean firstshow{get;set;}
    public Boolean secondshow{get;set;}
    public Boolean thirdshow{get;set;}
    public Boolean fourthshow{get;set;}
    public Boolean fifthshow{get;set;}
    public Boolean sixthshow{get;set;}
    public Boolean seventhshow{get;set;}
    public Boolean thanks{get;set;}

    public Boolean showDependentCheckboxes{get;set;}
    public Boolean showResidencyCheckboxes{get;set;}

    public List<SelectOption> incomeOptions{get;set;}
    public List<SelectOption> visaTypes{get;set;}
    public List<SelectOption> optionList{get;set;}
    public List<SelectOption> dependentAdd{get;set;}
    public List<SelectOption> resOptions{get;set;}
    public List<SelectOption> fileUploadOptions{get;set;}
    public String selectedOption{get;set;}
    public Boolean showOptions{get;set;}
    public List<Integer> iteratorList{get;set;}

    public String errorMessage{get;set;}
    public List<String> errorList{get;set;}
    public Boolean showError{get;set;}
    public Boolean showSuccess{get;set;}
    public Boolean otherVisa{get;set;}
    public String dependentString{get;set;}
    public String addressString{get;set;}

    public Boolean showUpload{get;set;}
    public List<AttachmentMeta> filenameList{get;set;}
    public String downloadUrl{get;set;}
    public String attachId{get;set;}
    public String caseIdFin;
    public List<String> widthList;
    public String currentWidth{get;set;}
    public String fileType{get;set;}

    public TaxationController(){
        String theID = System.currentPageReference().getParameters().get('taxId');
        String caseId = System.currentPageReference().getParameters().get('caseId');
        caseIdFin = caseId;
        if(theID != null){
            editMode = false;
            taxId = theID;
        }
        else{
            editMode = true;
        }
        tax = new Taxation__c();
        //tax.Id = 'a001g00000BcuiG';
        widthList = new List<String>{'width:17.3%;','width:34.3%;','width:50.3%;','width:67.3%;','width:83.3%;','width:100%;'};
        currentWidth = 'width:0%;';
        showError = false;
        showSuccess =false;
        errorList = new List<String>();
        errorMessage = 'Please fill in following fields : ';
        System.debug('@@MyActionMethod');
        current = 1;
        max = 7;
        showDependentCheckboxes = false;
        showResidencyCheckboxes = false;
        first = 'slds-progress__item slds-is-active';
        second = 'slds-progress__item';
        third = 'slds-progress__item';
        fourth = 'slds-progress__item';
        fifth = 'slds-progress__item';
        sixth = 'slds-progress__item';
        seventh = 'slds-progress__item';
        firstshow = true;
        secondshow = false;
        thirdshow = false;
        fourthshow = false;
        fifthshow = false;
        sixthshow = false;
        seventhshow = false;
        thanks = false;

        //firstshow = false;
        //seventhshow = true;

        taxx = new DataMapper();
        taxx.currentYear = String.valueOf(System.now().year());
        taxx.currentYearPlus1 = String.valueOf( Integer.valueOf(System.now().year()) + 1 );
        taxx.currentYear_1 = String.valueOf( Integer.valueOf(System.now().year()) - 1 );
        taxx.currentYear_2 = String.valueOf( Integer.valueOf(System.now().year()) - 2 );
        incomeOptions = new List<SelectOption>();
        visaTypes = new List<SelectOption>();
        visaTypes.add(new SelectOption('F1','F1'));
        visaTypes.add(new SelectOption('H1B','H1B'));
        visaTypes.add(new SelectOption('Other','Other'));
        dependentAdd = new List<SelectOption>();
        dependentAdd.add(new SelectOption('Child 1','Child 1'));
        dependentAdd.add(new SelectOption('Child 2','Child 2'));
        dependentAdd.add(new SelectOption('Other','Other'));
        resOptions = new List<SelectOption>();
        resOptions.add(new selectOption('Address 1','Address 1'));
        resOptions.add(new selectOption('Address 2','Address 2'));
        resOptions.add(new selectOption('Address 3','Address 3'));
        for(Integer i=1;i<=5;i++){
            incomeOptions.add(new SelectOption(String.valueOf(i),String.valueOf(i)));
        }

        taxx.dependents = false;
        taxx.showChild1 = false;
        taxx.showChild2 = false;
        taxx.showDependent = false;
        taxx.residencyDetails = false;
        taxx.resCurrentYear = false;
        taxx.resCurrentYearMinus1 = false;
        taxx.resCurrentYearMinus2 = false;
        taxx.stayed183Days = false;
        taxx.insuranceByEmployer = false;
        taxx.otherHealthCover = false;

        showOptions = false;
        iteratorList = new List<Integer>();
        taxx.bankDetails = new List<ForeignBankDetails>();
        taxx.bankDetails.add(new ForeignBankDetails());
        showOptions = true;

        optionList = new List<SelectOption>();
        optionList.add(new selectOption('Yes','Yes'));
        optionList.add(new selectOption('No','No'));

        otherVisa = false; 
        if(!editMode){
            getData(theID);
        }
        taxx.filenameList = new List<String>();
        taxx.filenameList.add('1098-T');
        showUpload = false;
        filenameList = new List<AttachmentMeta>();
        downloadUrl = 'https://'+Url.getSalesforceBaseUrl().getHost().split('--c.visualforce.com')[0];
        downloadUrl += '--c.documentforce.com/servlet/servlet.FileDownload?file=';

        fileUploadOptions = new List<SelectOption>();
        String lab = Label.MandatoryFileNames;
        for(String str : lab.split(',')){
            fileUploadOptions.add(new SelectOption(str,str));
        }
        fileUploadOptions.add(new SelectOption('Other','Other'));
    }

    public void getData(String theId){
        Taxation__c tax = [SELECT Id,business_income_this_tax_year__c,Case__c,Casualty_and_Theft_Loss__c,Change_in_Visa_Status__c,
                                    Child_1_Show__c,child_1__c,Child_2_Show__c,child_2__c,Comments_to_Preparer__c,ConnectionReceivedId,
                                    ConnectionSentId,Covered_by_Massachutteus_Insurance__c,CreatedById,CreatedDate,Currency__c,
                                    Current_Address__c,Date_of_Birth__c,Date_of_Marriage__c,dependents__c,Doctor_Dental_Orthodontist__c,
                                    Email_Id__c,Estimated_tax_paid__c,Filed_IOWA_tax_this_year__c,First_Name__c,
                                    First_Port_of_Entry_Date_into_US__c,Foreign_Income_Json__c,Glasses_Contacts__c,
                                    health_coverage_by_employer__c,Health_Coverage_by_You__c,Home_Number__c,Hospital_Charges__c,
                                    Interest_You_Paid__c,IsDeleted,Job_Title_with_Designation__c,Last_Name__c,Marital_Status_as_on_Dec_31__c,
                                    Maternity__c,Medical_Insurance_Premium__c,Middle_Name__c,Miles_Medical_Purpose__c,Mobile_Number__c,
                                    More_than_10000_in_FA_during_tax_year__c,more_than_50000_in_FIA_during_tax_year__c,
                                    Name,Name_of_Bank__c,Name_on_Bank_Account__c,Notes_for_tax_prepayerer__c,
                                    no_of_days_in_current_1_year__c,no_of_days_in_current_2_year__c,no_of_days_in_current_year__c,
                                    No_of_Months_stayed_in_US_Current_Year__c,Other_Dependent__c,Other_Show__c,
                                    Personal_Property_Tax_paid_If_any__c,Prescription_Drug__c,Real_Estate_Tax_Primary_Residency__c,
                                    Real_Estate_Tax_Secondary_Residency__c,Refer_your_friends__c,Rental_Year_for_tax_year__c,
                                    Residency_Current_Year_Minus_1__c,Residency_Current_Year_Minus_2__c,Residency_Current_Year__c,
                                    Residency__c,SSN_ITIN__c,Stay_more_than_183_days_next_year__c,SystemModstamp,
                                    Taxes_Paid_Last_year_on_State_Tax_Return__c,Taxpayer_Alimony_Paid__c,Taxpayer_contribution_towards_HSA__c,
                                    Taxpayer_Educator_Expense__c,Taxpayer_higher_ed_tuition_fee__c,Taxpayer_Json_current_1_year__c,
                                    Taxpayer_Json_current_2_year__c,Taxpayer_Json_current_year__c,Taxpayer_penalty_on_early_withdrawl__c,
                                    Taxpayer_Receipient_SSN__c,Taxpayer_Student_loan_interest__c,Taxpayer_traditional_IRA_contribution__c,
                                    Type_of_Account__c,type_of_return_for_current_1_year__c,US_Bank_Account_Number__c,US_Bank_Routing_Number__c,
                                    Visa_Type_as_on_Dec_31__c 
                                    FROM Taxation__c
                                    WHERE Id = :theId LIMIT 1];
        taxx.firstName = tax.First_Name__c;
        taxx.middleName = tax.Middle_Name__c;
        taxx.lastName = tax.Last_Name__c;
        taxx.ssn = tax.SSN_ITIN__c;
        taxx.dateOfBirth = tax.Date_of_Birth__c;
        taxx.visa = tax.Visa_Type_as_on_Dec_31__c;
        taxx.firstPortEntry = tax.First_Port_of_Entry_Date_into_US__c;
        taxx.changeInVisaStatus = tax.Change_in_Visa_Status__c;
        taxx.noOfMonthsForCurrentYear = Integer.valueOf(tax.No_of_Months_stayed_in_US_Current_Year__c);
        taxx.stayed183Days = tax.Stay_more_than_183_days_next_year__c;
        taxx.maritalStatus = tax.Marital_Status_as_on_Dec_31__c;
        taxx.dateOfmarriage = tax.Date_of_Marriage__c;
        taxx.currentAddress = tax.Current_Address__c;
        taxx.jobTitle = tax.Job_Title_with_Designation__c;
        taxx.cellNumber = Integer.valueOf(tax.Mobile_Number__c);
        taxx.homeNumber = Integer.valueOf(tax.Home_Number__c);
        taxx.email = tax.Email_Id__c;
        taxx.insuranceByEmployer = tax.health_coverage_by_employer__c;
        taxx.otherHealthCover = tax.Health_Coverage_by_You__c;

        taxx.noOfDaysInCurrent = Integer.valueOf(tax.no_of_days_in_current_year__c);
        taxx.noOfDaysInCurrentMinus1 = Integer.valueOf(tax.no_of_days_in_current_1_year__c);
        taxx.noOfDaysInCurrentMinus2 = Integer.valueOf(tax.no_of_days_in_current_2_year__c);
        taxx.typeOfReturnForCurrentMinus1 = tax.type_of_return_for_current_1_year__c;
        taxx.dependents = tax.dependents__c;
        taxx.showChild1 = tax.Child_1_Show__c;
        taxx.showChild2 = tax.Child_2_Show__c;
        taxx.showDependent = tax.Other_Show__c;

        if(taxx.showChild1 && tax.child_1__c != null){
            Map<String,Object> child1Map = new Map<String,Object>();
            child1Map = (Map<String,Object>)JSON.deserializeUntyped(tax.child_1__c);
            taxx.child1FirstName = (String)child1Map.get('child1FirstName');
            taxx.child1MiddleName = (String)child1Map.get('child1MiddleName');
            taxx.child1LastName = (String)child1Map.get('child1LastName');
            taxx.child1Relationship = (String)child1Map.get('child1Relationship');
            String temp = (String) child1Map.get('child1dob');
            if(!String.isBlank(temp)){
                List<String> tempArr = temp.split('-');
                if(tempArr.size() == 3)
                    taxx.child1dob = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
            taxx.child1ssn = (String)child1Map.get('child1ssn');
            taxx.child1VisaStatus = (String)child1Map.get('child1VisaStatus');
            //taxx.child1FirstPortEntry = (Date)child1Map.get('child1FirstPortEntry');
            String temp2 = (String) child1Map.get('child1FirstPortEntry');
            if(!String.isBlank(temp2)){
                List<String> tempArr = temp2.split('-');
                if(tempArr.size() == 3)
                    taxx.child1FirstPortEntry = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
            taxx.child1noofdays = (Integer)child1Map.get('child1noofdays');
            taxx.child1DependentName = (String)child1Map.get('child1DependentName');
            taxx.child1InstitutionName = (String)child1Map.get('child1InstitutionName');
            taxx.child1InsFedId = (String)child1Map.get('child1InsFedId');
            taxx.child1InsAddress = (String)child1Map.get('child1InsAddress');
            taxx.child1Amount = (Integer)child1Map.get('child1Amount');
            taxx.child1AmountReimbursed = (Integer)child1Map.get('child1AmountReimbursed');
        }
        if(taxx.showChild2 && tax.child_2__c != null){
            Map<String,Object> child1Map = new Map<String,Object>();
            child1Map = (Map<String,Object>)JSON.deserializeUntyped(tax.child_2__c);
            taxx.child2FirstName = (String)child1Map.get('child2FirstName');
            taxx.child2MiddleName = (String)child1Map.get('child2MiddleName');
            taxx.child2LastName = (String)child1Map.get('child2LastName');
            taxx.child2Relationship = (String)child1Map.get('child2Relationship');
            //taxx.child2dob = (Date)child1Map.get('child2dob');
            String temp = (String) child1Map.get('child2dob');
            if(!String.isBlank(temp)){
                List<String> tempArr = temp.split('-');
                if(tempArr.size() == 3)
                    taxx.child2dob = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
            taxx.child2ssn = (String)child1Map.get('child2ssn');
            taxx.child2VisaStatus = (String)child1Map.get('child2VisaStatus');
            //taxx.child2FirstPortEntry = (Date)child1Map.get('child2FirstPortEntry');
            String temp2 = (String) child1Map.get('child2FirstPortEntry');
            if(!String.isBlank(temp2)){
                List<String> tempArr = temp2.split('-');
                if(tempArr.size() == 3)
                    taxx.child2FirstPortEntry = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
            taxx.child2noofdays = (Integer)child1Map.get('child2noofdays');
            taxx.child2DependentName = (String)child1Map.get('child2DependentName');
            taxx.child2InstitutionName = (String)child1Map.get('child2InstitutionName');
            taxx.child2InsFedId = (String)child1Map.get('child2InsFedId');
            taxx.child2InsAddress = (String)child1Map.get('child2InsAddress');
            taxx.child2Amount = (Integer)child1Map.get('child2Amount');
            taxx.child2AmountReimbursed = (Integer)child1Map.get('child2AmountReimbursed');
        }
        if(taxx.showDependent && tax.Other_Dependent__c != null){
            Map<String,Object> child1Map = new Map<String,Object>();
            child1Map = (Map<String,Object>)JSON.deserializeUntyped(tax.Other_Dependent__c);

            taxx.otherFirstName = (String)child1Map.get('otherFirstName');
            taxx.otherMiddleName = (String)child1Map.get('otherMiddleName');
            taxx.otherLastName = (String)child1Map.get('otherLastName');
            taxx.otherRelationship = (String)child1Map.get('otherRelationship');
            //taxx.otherdob = (Date)child1Map.get('otherdob');
            String temp = (String) child1Map.get('otherdob');
            if(!String.isBlank(temp)){
                List<String> tempArr = temp.split('-');
                if(tempArr.size() == 3)
                    taxx.otherdob = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
            taxx.otherssn = (String)child1Map.get('otherssn');
            taxx.otherVisaStatus = (String)child1Map.get('otherVisaStatus');
            //taxx.otherFirstPortEntry = (Date)child1Map.get('otherFirstPortEntry');
            String temp2 = (String) child1Map.get('otherFirstPortEntry');
            if(!String.isBlank(temp2)){
                List<String> tempArr = temp2.split('-');
                if(tempArr.size() == 3)
                    taxx.otherFirstPortEntry = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
            taxx.othernoofdays = (Integer)child1Map.get('othernoofdays');
            taxx.otherDependentName = (String)child1Map.get('otherDependentName');
            taxx.otherInstitutionName = (String)child1Map.get('otherInstitutionName');
            taxx.otherInsFedId = (String)child1Map.get('otherInsFedId');
            taxx.otherInsAddress = (String)child1Map.get('otherInsAddress');
            taxx.otherAmount = (Integer)child1Map.get('otherAmount');
            taxx.otherAmountReimbursed = (Integer)child1Map.get('otherAmountReimbursed');
        }

        taxx.accountName = tax.Name_on_Bank_Account__c;
        taxx.bankName = tax.Name_of_Bank__c;
        taxx.bankRouting = tax.US_Bank_Routing_Number__c;
        if(tax.US_Bank_Account_Number__c != null)
            taxx.accountNumber = Integer.valueOf(tax.US_Bank_Account_Number__c);
        taxx.accountType = tax.Type_of_Account__c;
        taxx.residencyDetails = tax.Residency__c;
        taxx.resCurrentYear = tax.Residency_Current_Year__c;
        taxx.resCurrentYearMinus1 = tax.Residency_Current_Year_Minus_1__c;
        taxx.resCurrentYearMinus2 = tax.Residency_Current_Year_Minus_2__c;

        if(taxx.resCurrentYear && tax.Taxpayer_Json_current_year__c != null){
            Map<String,Object> temp = new Map<String,Object>();
            temp = (Map<String,Object>)JSON.deserializeUntyped(tax.Taxpayer_Json_current_year__c);
            taxx.currentStatesResided = (String)temp.get('currentStatesResided');
            //taxx.currentStayStartDate = (Date)temp.get('currentStayStartDate');
            String temp1 = (String) temp.get('currentStayStartDate');
            if(!String.isBlank(temp1)){
                List<String> tempArr = temp1.split('-');
                if(tempArr.size() == 3)
                    taxx.currentStayStartDate = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
            //taxx.currentStayEndDate = (Date)temp.get('currentStayEndDate');
            String temp2 = (String) temp.get('currentStayEndDate');
            if(!String.isBlank(temp2)){
                List<String> tempArr = temp2.split('-');
                if(tempArr.size() == 3)
                    taxx.currentStayEndDate = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
        }

        if(taxx.resCurrentYearMinus1 && tax.Taxpayer_Json_current_1_year__c != null){
            Map<String,Object> temp = new Map<String,Object>();
            temp = (Map<String,Object>)JSON.deserializeUntyped(tax.Taxpayer_Json_current_1_year__c);
            taxx.currentMinus1StatesResided = (String)temp.get('currentMinus1StatesResided');
            //taxx.currentMinus1StayStartDate = (Date)temp.get('currentMinus1StayStartDate');
            String temp1 = (String)temp.get('currentMinus1StayStartDate');
            if(!String.isBlank(temp1)){
                List<String> tempArr = temp1.split('-');
                if(tempArr.size() == 3)
                    taxx.currentMinus1StayStartDate = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
            //taxx.currentMinus1StayEndDate = (Date)temp.get('currentMinus1StayEndDate');
            String temp2 = (String) temp.get('currentMinus1StayEndDate');
            if(!String.isBlank(temp2)){
                List<String> tempArr = temp2.split('-');
                if(tempArr.size() == 3)
                    taxx.currentMinus1StayEndDate = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
        }

        if(taxx.resCurrentYearMinus2 && tax.Taxpayer_Json_current_2_year__c != null){
            Map<String,Object> temp = new Map<String,Object>();
            temp = (Map<String,Object>)JSON.deserializeUntyped(tax.Taxpayer_Json_current_2_year__c);
            taxx.currentMinus2StatesResided = (String)temp.get('currentMinus2StatesResided');
            //taxx.currentMinus2StayStartDate = (Date)temp.get('currentMinus2StayStartDate');
            String temp1 = (String) temp.get('currentMinus2StayStartDate');
            if(!String.isBlank(temp1)){
                List<String> tempArr = temp1.split('-');
                if(tempArr.size() == 3)
                    taxx.currentMinus2StayStartDate = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
            //taxx.currentMinus2StayEndDate = (Date)temp.get('currentMinus2StayEndDate');
            String temp2 = (String) temp.get('currentMinus2StayEndDate');
            if(!String.isBlank(temp2)){
                List<String> tempArr = temp2.split('-');
                if(tempArr.size() == 3)
                    taxx.currentMinus2StayEndDate = Date.newInstance(Integer.valueOf(tempArr[0]), Integer.valueOf(tempArr[1]), Integer.valueOf(tempArr[2]));
            }
        }

        taxx.mipAmount = Integer.valueOf(tax.Medical_Insurance_Premium__c);
        taxx.pdAmount = Integer.valueOf(tax.Prescription_Drug__c);
        taxx.glassAmount = Integer.valueOf(tax.Glasses_Contacts__c);
        taxx.hospitalChargesAmount = Integer.valueOf(tax.Hospital_Charges__c);
        taxx.doctorAmount = Integer.valueOf(tax.Doctor_Dental_Orthodontist__c);
        taxx.maternityAmount = Integer.valueOf(tax.Maternity__c);
        taxx.milesAmount = Integer.valueOf(tax.Miles_Medical_Purpose__c);
        taxx.realEstatePrimaryRes = Integer.valueOf(tax.Real_Estate_Tax_Primary_Residency__c);
        taxx.realEstateSecondaryRes = Integer.valueOf(tax.Real_Estate_Tax_Secondary_Residency__c);
        taxx.personalPropertyTax = Integer.valueOf(tax.Personal_Property_Tax_paid_If_any__c);
        taxx.stateTaxReturnTax = Integer.valueOf(tax.Taxes_Paid_Last_year_on_State_Tax_Return__c);

        Map<String,Object> tempMap = new Map<String,Object>();
        if(tax.Interest_You_Paid__c != null){
        	tempMap = (Map<String,Object>)JSON.deserializeUntyped(tax.Interest_You_Paid__c);
            taxx.primaryHomeMortgageInterest = (Integer)tempMap.get('primaryHomeMortgageInterest');
            taxx.primaryHomeMortgageIntPaid = (Integer)tempMap.get('primaryHomeMortgageIntPaid');
            taxx.primaryMortgageInsPaid = (Integer)tempMap.get('primaryMortgageInsPaid');
            taxx.secondaryHomeMortgageInterest = (Integer)tempMap.get('secondaryHomeMortgageInterest');
            taxx.secondaryHomeMortgageIntPaid = (Integer)tempMap.get('secondaryHomeMortgageIntPaid');
            taxx.secondaryMortgageInsPaid = (Integer)tempMap.get('secondaryMortgageInsPaid');   
        }
        
        taxx.commentsToPreparer = tax.Comments_to_Preparer__c;

        /*List<Map<String,Object>> listOfMap = new List<Map<String,Object>>();
        for(ForeignBankDetails fbd : taxx.bankDetails){
            Map<String,Object> tempMap2 = new Map<String,Object>();
            tempMap2.put('nameofcountry',fbd.nameofcountry);
            tempMap2.put('salaryincome',fbd.salaryincome);
            tempMap2.put('dividendincome',fbd.dividendincome);
            tempMap2.put('interestincome',fbd.interestincome);
            tempMap2.put('rentalincome',fbd.rentalincome);
            listOfMap.add(tempMap2);
        }*/
        //tax.Foreign_Income_Json__c = JSON.serialize(listOfMap);
        List<Object> listMap = new List<Object>();
        if(tax.Foreign_Income_Json__c != null){
          	listMap = (List<Object>)JSON.deserializeUntyped(tax.Foreign_Income_Json__c);
            taxx.bankDetails = new List<ForeignBankDetails>();
            for(Object objMap : listMap){
                Map<String,Object> forMap = (Map<String,Object>)objMap;
                ForeignBankDetails fbd = new ForeignBankDetails();
                fbd.nameofcountry = (String) forMap.get('nameofcountry');
                fbd.salaryincome = (Integer) forMap.get('salaryincome');
                fbd.dividendincome = (Integer)forMap.get('dividendincome');
                fbd.interestincome =(Integer) forMap.get('interestincome');
                fbd.rentalincome =(Integer) forMap.get('rentalincome');
                taxx.bankDetails.add(fbd);
            }  
        }
        

        taxx.educatorExpense = tax.Taxpayer_Educator_Expense__c;
        taxx.hsaContribution = tax.Taxpayer_contribution_towards_HSA__c;
        taxx.penaltyEarlyWithdrawlSaving = tax.Taxpayer_penalty_on_early_withdrawl__c;
        taxx.alimonyPaid = tax.Taxpayer_Alimony_Paid__c;
        taxx.receipientssn = tax.Taxpayer_Receipient_SSN__c;
        taxx.iraContribution = tax.Taxpayer_traditional_IRA_contribution__c;
        taxx.studentLoan = tax.Taxpayer_Student_loan_interest__c;
        taxx.higherEdTutionFee = tax.Taxpayer_higher_ed_tuition_fee__c;

        /*tax.More_than_10000_in_FA_during_tax_year__c = taxx.moreThan10000 == 'Yes' ? true : false ;
        tax.more_than_50000_in_FIA_during_tax_year__c = taxx.moreThan50000 == 'Yes' ? true : false ;
        tax.business_income_this_tax_year__c = taxx.hasBusinessIncome == 'Yes' ? true : false ;
        tax.Rental_Year_for_tax_year__c = taxx.hasRentalIncome == 'Yes' ? true : false ;
        tax.Filed_IOWA_tax_this_year__c = taxx.hasIOWAIncome == 'Yes' ? true : false ;
        tax.Covered_by_Massachutteus_Insurance__c = taxx.hasMassachusetts == 'Yes' ? true : false ;
        tax.Casualty_and_Theft_Loss__c = taxx.casualtyTheftLoses == 'Yes' ? true : false ;
        tax.Estimated_tax_paid__c = taxx.estimatedTax == 'Yes' ? true : false ;
        */
        taxx.moreThan10000 = tax.More_than_10000_in_FA_during_tax_year__c ? 'Yes' : 'No';
        taxx.moreThan50000 = tax.more_than_50000_in_FIA_during_tax_year__c ? 'Yes' : 'No';
        taxx.hasBusinessIncome = tax.business_income_this_tax_year__c ? 'Yes' : 'No';
        taxx.hasRentalIncome = tax.Rental_Year_for_tax_year__c ? 'Yes' : 'No';
        taxx.hasIOWAIncome = tax.Filed_IOWA_tax_this_year__c ? 'Yes' : 'No';
        taxx.hasMassachusetts = tax.Covered_by_Massachutteus_Insurance__c ? 'Yes' : 'No';
        taxx.casualtyTheftLoses = tax.Casualty_and_Theft_Loss__c ? 'Yes' : 'No';
        taxx.estimatedTax = tax.Estimated_tax_paid__c ? 'Yes' : 'No';
        taxx.notes = tax.Notes_for_tax_prepayerer__c;
    }

    public Pagereference addFile(){
        showUpload = true;
        showError = false;
        showSuccess = false;
        
        return null;
        //return addDatainList();
    }

    public void nextPage(){
        //errorList = new List<String>();
        //errorMessage = 'Please fill in following fields : ';
        System.debug('@@first'+this.taxx.firstName);
        System.debug('@@midd'+this.taxx.middleName);
        System.debug('@@last'+this.taxx.lastName);
        System.debug('@@first'+taxx.firstName);
        System.debug('@@came');
        showSuccess = false;
        Boolean goNext = true;
        errorList = new List<String>();
        errorMessage = 'Please fill in following fields : ';
        if(current == 1){
            if(caseIdFin == null || caseIdFin == ''){
                goNext = false;
                showError = true;
                errorMessage = 'Please enter case Id in the Url.';
                //errorList.add('Case Id')
            }
            else if(this.taxx.firstName != null && this.taxx.lastName != null && this.taxx.ssn != null && this.taxx.dateOfBirth != null 
                && this.taxx.visa != null){
                goNext = true;
            }
            else{
                goNext = false;
                if(String.isBlank(this.taxx.firstName)) errorList.add('First name');
                if(String.isBlank(this.taxx.lastName)) errorList.add('Last name');
                if(String.isBlank(this.taxx.ssn)) errorList.add('SSN');
                if(String.isBlank(String.valueOf(this.taxx.dateOfBirth))) errorList.add('Date of Birth');
                if(String.isBlank(this.taxx.visa)) errorList.add('Visa type');
            }
            if(taxx.otherHealthCover){
                taxx.filenameList.add('1095-A');
            }
        }
        else{
            goNext = true;
        }
        if(!errorList.isEmpty()){
            String last = errorList[errorList.size()-1];
            for(String str : errorList){
                if(str != last){
                    errorMessage += str + ', ';
                }
                else{
                    errorMessage += str+'.';
                }
            }
        }
        System.debug('@@goNext'+goNext);
        if(goNext){
            showError = false;
            Boolean check = false;
            System.debug('@@current'+current);
            if(current == 6){
                try{
                    System.debug('@@try');
                    processDate();
                    check = true;
                }
                catch(Exception e){
                    System.debug('@@catch');
                    errorMessage = 'Follow error occured: '+e.getMessage();
                    showError = true;
                    current = 6;
                    check = false;
                    updateclass();
                }
            }
            System.debug('@@check'+check);
            if((current != 6 && !check) || (current == 6 && check)){
                if(current < max){
                    current ++;
                }
                updateclass();
            }
        }
        else{
            showError = true;
        }
    }
    public Pagereference prevPage(){
        showSuccess = false;
        if(current > 0){
            current --;
        }
        updateclass();
        return null;
    }
    public Boolean getShowPrev(){
        return current > 1 && current <= max ? true : false;
    }
    public Boolean getShowNext(){
        return current < max ? true : false;
    }
    public Boolean getShowSave(){
        return current == max ? true : false;
    }
    public void updateclass(){
        System.debug('@@current'+current);
        if(current == 1){
            first = 'slds-progress__item slds-is-active';
            second = 'slds-progress__item';
            third = 'slds-progress__item';
            fourth = 'slds-progress__item';
            fifth = 'slds-progress__item';
            sixth = 'slds-progress__item';
            seventh = 'slds-progress__item';

            firstshow = true;
            secondshow = false;
            thirdshow = false;
            fourthshow = false;
            fifthshow = false;
            sixthshow = false;
            seventhshow = false;
            thanks = false;
            currentWidth = 'width:0%;';
        }
        else if(current == 2){
            first = 'slds-progress__item slds-is-completed';
            second = 'slds-progress__item slds-is-active';
            third = 'slds-progress__item';
            fourth = 'slds-progress__item';
            fifth = 'slds-progress__item';
            sixth = 'slds-progress__item';
            seventh = 'slds-progress__item';

            firstshow = false;
            secondshow = true;
            thirdshow = false;
            fourthshow = false;
            fifthshow = false;
            sixthshow = false;
            seventhshow = false;
            thanks = false;
            currentWidth = widthList[0];
        }
        else if(current == 3){
            first = 'slds-progress__item slds-is-completed';
            second = 'slds-progress__item slds-is-completed';
            third = 'slds-progress__item slds-is-active';
            fourth = 'slds-progress__item';
            fifth = 'slds-progress__item';
            sixth = 'slds-progress__item';
            seventh = 'slds-progress__item';

            firstshow = false;
            secondshow = false;
            thirdshow = true;
            fourthshow = false;
            fifthshow = false;
            sixthshow = false;
            seventhshow = false;
            thanks = false;
            currentWidth = widthList[1];
        }
        else if(current == 4){
            first = 'slds-progress__item slds-is-completed';
            second = 'slds-progress__item slds-is-completed';
            third = 'slds-progress__item slds-is-completed';
            fourth = 'slds-progress__item slds-is-active';
            fifth = 'slds-progress__item';
            sixth = 'slds-progress__item';
            seventh = 'slds-progress__item';

            firstshow = false;
            secondshow = false;
            thirdshow = false;
            fourthshow = true;
            fifthshow = false;
            sixthshow = false;
            seventhshow = false;
            thanks = false;
            currentWidth = widthList[2];
        }
        else if(current == 5){
            first = 'slds-progress__item slds-is-completed';
            second = 'slds-progress__item slds-is-completed';
            third = 'slds-progress__item slds-is-completed';
            fourth = 'slds-progress__item slds-is-completed';
            fifth = 'slds-progress__item slds-is-active';
            sixth = 'slds-progress__item';
            seventh = 'slds-progress__item';

            firstshow = false;
            secondshow = false;
            thirdshow = false;
            fourthshow = false;
            fifthshow = true;
            sixthshow = false;
            seventhshow = false;
            thanks = false;
            currentWidth = widthList[3];
        }
        else if(current == 6){
            first = 'slds-progress__item slds-is-completed';
            second = 'slds-progress__item slds-is-completed';
            third = 'slds-progress__item slds-is-completed';
            fourth = 'slds-progress__item slds-is-completed';
            fifth = 'slds-progress__item slds-is-completed';
            sixth = 'slds-progress__item slds-is-active';
            seventh = 'slds-progress__item';

            firstshow = false;
            secondshow = false;
            thirdshow = false;
            fourthshow = false;
            fifthshow = false;
            sixthshow = true;
            seventhshow = false;
            thanks = false;
            currentWidth = widthList[4];
        }
        else if(current == 7){
            first = 'slds-progress__item slds-is-completed';
            second = 'slds-progress__item slds-is-completed';
            third = 'slds-progress__item slds-is-completed';
            fourth = 'slds-progress__item slds-is-completed';
            fifth = 'slds-progress__item slds-is-completed';
            sixth = 'slds-progress__item slds-is-completed';
            seventh = 'slds-progress__item slds-is-active';

            firstshow = false;
            secondshow = false;
            thirdshow = false;
            fourthshow = false;
            fifthshow = false;
            sixthshow = false;
            seventhshow = true;
            thanks = false;
            currentWidth = widthList[5];
        }
        System.debug('@@taxx'+taxx);
    }
    public Pagereference updatePage(){
        System.debug('@@uploadlater'+ taxx.uploadLater );
        System.debug('@@now'+ taxx.uploadNow );
        return null;
    }
    
    public Pagereference dependentUpdates(){
        if(taxx.dependents){
            showDependentCheckboxes = true;
        }
        else{
            showDependentCheckboxes = false;
        }
        if(!showDependentCheckboxes){
            taxx.showChild1 = false;
            taxx.showChild2 = false;
            taxx.showDependent = false;
        }
        return null;
    }
    public Pagereference residencyUpdates(){
        if(taxx.residencyDetails){
            showResidencyCheckboxes = true;
        }
        else{
            showResidencyCheckboxes = false;
        }
        if(!showResidencyCheckboxes){
            taxx.resCurrentYear = false;
            taxx.resCurrentYearMinus1 = false;
            taxx.resCurrentYearMinus2 = false;
        }
        return null;
    }
    public Pagereference handleValueChange(){
        taxx.bankDetails = new List<ForeignBankDetails>();
        showOptions = true;
        if(selectedOption != null){
            Integer temp = Integer.valueOf(selectedOption);
            for(Integer i=1;i<=temp;i++){
                iteratorList.add(i);
                taxx.bankDetails.add(new ForeignBankDetails());
            }
        }
        return null;
    }
    public Pagereference handleVisaChange(){
        if(taxx.visa == 'Other'){
            otherVisa = true;
        }
        else{
            otherVisa = false;
        }
        return null;
    }
    public Pagereference handleDependents(){
        System.debug('@@'+dependentString); 
        System.debug('@@'+addressString);
        return null;
    }
    
    public Pagereference addDepend(){
        System.debug('@@dependentString'+dependentString);
        List<SelectOption> soOption = new List<SelectOption>();
        soOption = dependentAdd;
        for(Integer i=0; i< dependentAdd.size();i++){
            if(dependentAdd[i].getLabel() == dependentString){
                dependentAdd.remove(i);
                break;
            }
        }
        taxx.dependents = true;
        if(dependentString == 'Child 1'){
            taxx.showChild1 = true;
        }
        if(dependentString == 'Child 2'){
            taxx.showChild2 = true;
        }
        if(dependentString == 'Other'){
            taxx.showDependent = true;
        }
        return null;
    }

    public Boolean getShowAddressAdd(){
        return resOptions.size() > 0 ? true : false;
    }
    public Boolean getShowDependentAdd(){
        return dependentAdd.size() > 0 ? true : false;
    }

    public Pagereference addAddress(){
        System.debug('@@addressString'+addressString);
        for(Integer i=0; i< resOptions.size();i++){
            if(resOptions[i].getLabel() == addressString){
                resOptions.remove(i);
                break;
            }
        }
        taxx.residencyDetails = true;
        if(addressString == 'Address 1'){
            taxx.resCurrentYear = true;
        }
        if(addressString == 'Address 2'){
            taxx.resCurrentYearMinus1 = true;
        }
        if(addressString == 'Address 3'){
            taxx.resCurrentYearMinus2 = true;
        }
        return null;
    }
    public Pagereference saveMe(){
        showSuccess = false;
        List<String> mylist = validateFirst();
        System.debug('@@mylist'+mylist);
        Boolean val = true;
        if(mylist.isEmpty()){
            val = true;
        }
        else{
            val = false;
        }
        if(!val){
            errorMessage = 'Please make sure file name or description should exactly match. Please upload following files: ';
            String temp = mylist[mylist.size()-1];
            for(String str : mylist){
                if(str == temp){
                    errorMessage += str + '.';
                }
                else{
                    errorMessage += str + ', ';
                }
            }
            showError = true;
            return null;
        }
        else{
            showError = false;
        }
        current++;
        first = 'slds-progress__item slds-is-completed';
        second = 'slds-progress__item slds-is-completed';
        third = 'slds-progress__item slds-is-completed';
        fourth = 'slds-progress__item slds-is-completed';
        fifth = 'slds-progress__item slds-is-completed';
        sixth = 'slds-progress__item slds-is-completed';
        seventh = 'slds-progress__item slds-is-completed';
        firstshow = false;
        secondshow = false;
        thirdshow = false;
        fourthshow = false;
        fifthshow = false;
        sixthshow = false;
        seventhshow = false;
        thanks = true;
        showError = false;
        errorMessage = '';
        tax.Ready_to_consider__c = true;
        update tax;
        return null;
    }
    public List<String> validateFirst(){
        System.debug('@@uploadLater'+taxx.uploadLater);
        System.debug('@@now'+taxx.uploadNow);
        List<String> fileList = new List<String>();
        fileList = taxx.filenameList;
        System.debug('@@came in validate firstfileList'+fileList);
        
        List<Attachment> attList = [SELECT Id,Name,Description FROM Attachment WHERE ParentId=:tax.Id];

        for(Integer i=0;i<fileList.size();i++){
            if(taxx.uploadLater != null && taxx.uploadLater && fileList[i] == '1098-T'){
                fileList.remove(i);
            }
        }
        for(Attachment att : attList){
            System.debug('@@came in validate firstatt:'+att);
            for(Integer i=0;i<fileList.size();i++){
                if(att.Name.equalsIgnoreCase(fileList[i])  || att.Description.equalsIgnoreCase(fileList[i])){
                    fileList.remove(i);
                    continue;
                }
            }
        }
        return fileList;
    }
    public void updateData(){
        System.debug('@@this');
    }

    public void processDate(){
        System.debug('@@taxx'+taxx);
        System.debug('@@accountNumber'+taxx.accountNumber);
        System.debug('@@homeNumber'+taxx.homeNumber);
        //tax = new Taxation__c();
        //tax.Case__c = '5001g000009ldip';
        if(tax.Id == null){
            tax.Case__c = caseIdFin;
        }
        tax.First_Name__c = taxx.firstName;
        tax.Middle_Name__c = taxx.middleName;
        tax.Last_Name__c = taxx.lastName;
        tax.SSN_ITIN__c = taxx.ssn;
        tax.Date_of_Birth__c = taxx.dateOfBirth;
        tax.Visa_Type_as_on_Dec_31__c = taxx.visa;
        tax.First_Port_of_Entry_Date_into_US__c = taxx.firstPortEntry;
        tax.Change_in_Visa_Status__c = taxx.changeInVisaStatus;
        tax.No_of_Months_stayed_in_US_Current_Year__c = taxx.noOfMonthsForCurrentYear;
        tax.Stay_more_than_183_days_next_year__c = taxx.stayed183Days;
        tax.Marital_Status_as_on_Dec_31__c = taxx.maritalStatus;
        tax.Date_of_Marriage__c = taxx.dateOfmarriage;
        tax.Current_Address__c = taxx.currentAddress;
        tax.Job_Title_with_Designation__c = taxx.jobTitle;
        tax.Mobile_Number__c = String.valueOf(taxx.cellNumber);
        tax.Home_Number__c = String.valueOf(taxx.homeNumber);
        tax.Email_Id__c = taxx.email;
        tax.health_coverage_by_employer__c = taxx.insuranceByEmployer;
        tax.Health_Coverage_by_You__c = taxx.otherHealthCover;

        tax.no_of_days_in_current_year__c = taxx.noOfDaysInCurrent;
        tax.no_of_days_in_current_1_year__c = taxx.noOfDaysInCurrentMinus1;
        tax.no_of_days_in_current_2_year__c = taxx.noOfDaysInCurrentMinus2;
        tax.type_of_return_for_current_1_year__c = taxx.typeOfReturnForCurrentMinus1;
        tax.dependents__c = taxx.dependents;
        tax.Child_1_Show__c = taxx.showChild1;
        tax.Child_2_Show__c = taxx.showChild2;
        tax.Other_Show__c = taxx.showDependent;

        System.debug('@@taxx.showChild1'+taxx.showChild1);

        if(taxx.showChild1){
            Map<String,Object> child1Map = new Map<String,Object>();
            child1Map.put('child1FirstName',taxx.child1FirstName);
            child1Map.put('child1MiddleName',taxx.child1MiddleName);
            child1Map.put('child1LastName',taxx.child1LastName);
            child1Map.put('child1Relationship',taxx.child1Relationship);
            child1Map.put('child1dob',taxx.child1dob);
            child1Map.put('child1ssn',taxx.child1ssn);
            child1Map.put('child1VisaStatus',taxx.child1VisaStatus);
            child1Map.put('child1FirstPortEntry',taxx.child1FirstPortEntry);
            child1Map.put('child1noofdays',taxx.child1noofdays);
            child1Map.put('child1DependentName',taxx.child1DependentName);
            child1Map.put('child1InstitutionName',taxx.child1InstitutionName);
            child1Map.put('child1InsFedId',taxx.child1InsFedId);
            child1Map.put('child1InsAddress',taxx.child1InsAddress);
            child1Map.put('child1Amount',taxx.child1Amount);
            child1Map.put('child1AmountReimbursed',taxx.child1AmountReimbursed);
            tax.child_1__c = JSON.serialize(child1Map);
        }
        if(taxx.showChild2){
            Map<String,Object> child1Map = new Map<String,Object>();
            child1Map.put('child2FirstName',taxx.child2FirstName);
            child1Map.put('child2MiddleName',taxx.child2MiddleName);
            child1Map.put('child2LastName',taxx.child2LastName);
            child1Map.put('child2Relationship',taxx.child2Relationship);
            child1Map.put('child2dob',taxx.child2dob);
            child1Map.put('child2ssn',taxx.child2ssn);
            child1Map.put('child2VisaStatus',taxx.child2VisaStatus);
            child1Map.put('child2FirstPortEntry',taxx.child2FirstPortEntry);
            child1Map.put('child2noofdays',taxx.child2noofdays);
            child1Map.put('child2DependentName',taxx.child2DependentName);
            child1Map.put('child2InstitutionName',taxx.child2InstitutionName);
            child1Map.put('child2InsFedId',taxx.child2InsFedId);
            child1Map.put('child2InsAddress',taxx.child2InsAddress);
            child1Map.put('child2Amount',taxx.child2Amount);
            child1Map.put('child2AmountReimbursed',taxx.child2AmountReimbursed);
            tax.child_2__c = JSON.serialize(child1Map);
        }
        if(taxx.showDependent){
            Map<String,Object> child1Map = new Map<String,Object>();
            child1Map.put('otherFirstName',taxx.otherFirstName);
            child1Map.put('otherMiddleName',taxx.otherMiddleName);
            child1Map.put('otherLastName',taxx.otherLastName);
            child1Map.put('otherRelationship',taxx.otherRelationship);
            child1Map.put('otherdob',taxx.otherdob);
            child1Map.put('otherssn',taxx.otherssn);
            child1Map.put('otherVisaStatus',taxx.otherVisaStatus);
            child1Map.put('otherFirstPortEntry',taxx.otherFirstPortEntry);
            child1Map.put('othernoofdays',taxx.othernoofdays);
            child1Map.put('otherDependentName',taxx.otherDependentName);
            child1Map.put('otherInstitutionName',taxx.otherInstitutionName);
            child1Map.put('otherInsFedId',taxx.otherInsFedId);
            child1Map.put('otherInsAddress',taxx.otherInsAddress);
            child1Map.put('otherAmount',taxx.otherAmount);
            child1Map.put('otherAmountReimbursed',taxx.otherAmountReimbursed);
            tax.Other_Dependent__c = JSON.serialize(child1Map);
        }
        tax.Name_on_Bank_Account__c = taxx.accountName;
        tax.Name_of_Bank__c = taxx.bankName;
        tax.US_Bank_Routing_Number__c = taxx.bankRouting;
        tax.US_Bank_Account_Number__c = String.valueOf(taxx.accountNumber);
        tax.Type_of_Account__c = taxx.accountType;
        tax.Residency__c = taxx.residencyDetails;
        tax.Residency_Current_Year__c = taxx.resCurrentYear;
        tax.Residency_Current_Year_Minus_1__c = taxx.resCurrentYearMinus1;
        tax.Residency_Current_Year_Minus_2__c = taxx.resCurrentYearMinus2;

        if(taxx.resCurrentYear){
            Map<String,Object> temp = new Map<String,Object>();
            temp.put('currentStatesResided',taxx.currentStatesResided);
            temp.put('currentStayStartDate',taxx.currentStayStartDate);
            temp.put('currentStayEndDate',taxx.currentStayEndDate);
            tax.Taxpayer_Json_current_year__c = JSON.serialize(temp);
        }

        if(taxx.resCurrentYearMinus1){
            Map<String,Object> temp = new Map<String,Object>();
            temp.put('currentMinus1StatesResided',taxx.currentMinus1StatesResided);
            temp.put('currentMinus1StayStartDate',taxx.currentMinus1StayStartDate);
            temp.put('currentMinus1StayEndDate',taxx.currentMinus1StayEndDate);
            tax.Taxpayer_Json_current_1_year__c = JSON.serialize(temp);
        }

        if(taxx.resCurrentYearMinus2){
            Map<String,Object> temp = new Map<String,Object>();
            temp.put('currentMinus2StatesResided',taxx.currentMinus2StatesResided);
            temp.put('currentMinus2StayStartDate',taxx.currentMinus2StayStartDate);
            temp.put('currentMinus2StayEndDate',taxx.currentMinus2StayEndDate);
            tax.Taxpayer_Json_current_2_year__c = JSON.serialize(temp);
        }
        tax.Medical_Insurance_Premium__c = taxx.mipAmount;
        tax.Prescription_Drug__c = taxx.pdAmount;
        tax.Glasses_Contacts__c = taxx.glassAmount;
        tax.Hospital_Charges__c = taxx.hospitalChargesAmount;
        tax.Doctor_Dental_Orthodontist__c = taxx.doctorAmount;
        tax.Maternity__c = taxx.maternityAmount;
        tax.Miles_Medical_Purpose__c = taxx.milesAmount;
        tax.Real_Estate_Tax_Primary_Residency__c = taxx.realEstatePrimaryRes;
        tax.Real_Estate_Tax_Secondary_Residency__c = taxx.realEstateSecondaryRes;
        tax.Personal_Property_Tax_paid_If_any__c = taxx.personalPropertyTax;
        tax.Taxes_Paid_Last_year_on_State_Tax_Return__c = taxx.stateTaxReturnTax;

        Map<String,Object> tempMap = new Map<String,Object>();
        tempMap.put('primaryHomeMortgageInterest',taxx.primaryHomeMortgageInterest);
        tempMap.put('primaryHomeMortgageIntPaid',taxx.primaryHomeMortgageIntPaid);
        tempMap.put('primaryMortgageInsPaid',taxx.primaryMortgageInsPaid);
        tempMap.put('secondaryHomeMortgageInterest',taxx.secondaryHomeMortgageInterest);
        tempMap.put('secondaryHomeMortgageIntPaid',taxx.secondaryHomeMortgageIntPaid);
        tempMap.put('secondaryMortgageInsPaid',taxx.secondaryMortgageInsPaid);
        tax.Interest_You_Paid__c = JSON.serialize(tempMap);
        tax.Comments_to_Preparer__c = taxx.commentsToPreparer;

        List<Map<String,Object>> listOfMap = new List<Map<String,Object>>();
        for(ForeignBankDetails fbd : taxx.bankDetails){
            Map<String,Object> tempMap2 = new Map<String,Object>();
            tempMap2.put('nameofcountry',fbd.nameofcountry);
            tempMap2.put('salaryincome',fbd.salaryincome);
            tempMap2.put('dividendincome',fbd.dividendincome);
            tempMap2.put('interestincome',fbd.interestincome);
            tempMap2.put('rentalincome',fbd.rentalincome);
            listOfMap.add(tempMap2);
        }
        tax.Foreign_Income_Json__c = JSON.serialize(listOfMap);
        tax.Taxpayer_Educator_Expense__c = taxx.educatorExpense;
        tax.Taxpayer_contribution_towards_HSA__c = taxx.hsaContribution;
        tax.Taxpayer_penalty_on_early_withdrawl__c = taxx.penaltyEarlyWithdrawlSaving;
        tax.Taxpayer_Alimony_Paid__c = taxx.alimonyPaid;
        tax.Taxpayer_Receipient_SSN__c = taxx.receipientssn;
        tax.Taxpayer_traditional_IRA_contribution__c = taxx.iraContribution;
        tax.Taxpayer_Student_loan_interest__c = taxx.studentLoan;
        tax.Taxpayer_higher_ed_tuition_fee__c = taxx.higherEdTutionFee;

        tax.More_than_10000_in_FA_during_tax_year__c = taxx.moreThan10000 == 'Yes' ? true : false ;
        tax.more_than_50000_in_FIA_during_tax_year__c = taxx.moreThan50000 == 'Yes' ? true : false ;
        tax.business_income_this_tax_year__c = taxx.hasBusinessIncome == 'Yes' ? true : false ;
        tax.Rental_Year_for_tax_year__c = taxx.hasRentalIncome == 'Yes' ? true : false ;
        tax.Filed_IOWA_tax_this_year__c = taxx.hasIOWAIncome == 'Yes' ? true : false ;
        tax.Covered_by_Massachutteus_Insurance__c = taxx.hasMassachusetts == 'Yes' ? true : false ;
        tax.Casualty_and_Theft_Loss__c = taxx.casualtyTheftLoses == 'Yes' ? true : false ;
        tax.Estimated_tax_paid__c = taxx.estimatedTax == 'Yes' ? true : false ;

        tax.Notes_for_tax_prepayerer__c = taxx.notes;
        upsert tax;
        taxId = tax.Id;
    }

    public PageReference upload() {
        System.debug('@@tax'+fileType);
        attachment.Description = fileType;
        attachment.ParentId = tax.id;
        //attachment.IsPrivate = true;
        try {
            insert attachment;
        } catch (Exception e) {
            System.debug('@@@Exception'+e.getMessage());
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'+e.getMessage()));
            errorMessage = 'Error uploading attachment:'+e.getMessage();
            showError = true;
            return null;
        } finally {
            attachment = new Attachment(); 
        }
        showError = false;
        showSuccess = true;
        showUpload = false;
        addDatainList();
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        return null;
    }
    public Boolean getShowFileUploadSection(){
        return filenameList.size() > 0 ? true : false;
    }

    public Pagereference addDatainList(){
        System.debug('@@came to upload');
        filenameList = new List<AttachmentMeta>();
        //fileNames = new List<String>();
        for(Attachment att : [SELECT Id,Name,Description FROM Attachment WHERE ParentId=:tax.Id]){
            AttachmentMeta am = new AttachmentMeta();
            am.fileName = att.Description;
            am.fileValue = att.Name;
            am.fileId = att.Id;
            filenameList.add(am);
            //fileNames.add(att.Name);
        }
        showUpload = false;
        //fileName = '';
        return null;
    }
    public Pagereference removeFile(){
        System.debug('@@attachId'+attachId);
        if(attachId != null){
            Attachment att = new Attachment();
            att.Id = attachId;
            delete att;
        }
        //return null;
        return addDatainList();
    }

}