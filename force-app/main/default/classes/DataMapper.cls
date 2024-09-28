public class DataMapper{
    public String firstName{get;set;}
    public String middleName{get;set;}
    public String lastName{get;set;}
    public String ssn{get;set;}
    public Date dateOfBirth{get;set;}
    public String visa{get;set;}
    public String otherVisaValue{get;set;}
    public Date firstPortEntry{get;set;}
    public String changeInVisaStatus{get;set;}
    public Integer noOfMonthsForCurrentYear{get;set;}
    public Boolean stayed183Days{get;set;}
    public String maritalStatus{get;set;}
    public Date dateOfmarriage{get;set;}
    public String currentAddress{get;set;}
    public String jobTitle{get;set;}
    public Integer homeNumber{get;set;}
    public Integer cellNumber{get;set;}
    public String email{get;set;}
    public Boolean insuranceByEmployer{get;set;}
    public Boolean otherHealthCover{get;set;}

    public Integer noOfDaysInCurrent{get;set;}
    public Integer noOfDaysInCurrentMinus1{get;set;}
    public Integer noOfDaysInCurrentMinus2{get;set;}
    public String typeOfReturnForCurrentMinus1{get;set;}
    public Boolean dependents{get;set;}
    public Boolean showChild1{get;set;}
    public Boolean showChild2{get;set;}
    public Boolean showDependent{get;set;}

    //Child 1 details
    public String child1FirstName{get;set;}
    public String child1MiddleName{get;set;}
    public String child1LastName{get;set;}
    public String child1Relationship{get;set;}
    public Date child1dob{get;set;}
    public String child1ssn{get;set;}
    public String child1VisaStatus{get;set;}
    public Date child1FirstPortEntry{get;set;}
    public Integer child1noofdays{get;set;}
    
    public String child1DependentName{get;set;}
    public String child1InstitutionName{get;set;}
    public String child1InsFedId{get;set;}
    public String child1InsAddress{get;set;}
    public Integer child1Amount{get;set;}
    public Integer child1AmountReimbursed{get;set;}

    //Child 2 details
    public String child2FirstName{get;set;}
    public String child2MiddleName{get;set;}
    public String child2LastName{get;set;}
    public String child2Relationship{get;set;}
    public Date child2dob{get;set;}
    public String child2ssn{get;set;}
    public String child2VisaStatus{get;set;}
    public Date child2FirstPortEntry{get;set;}
    public Integer child2noofdays{get;set;}
    
    public String child2DependentName{get;set;}
    public String child2InstitutionName{get;set;}
    public String child2InsFedId{get;set;}
    public String child2InsAddress{get;set;}
    public Integer child2Amount{get;set;}
    public Integer child2AmountReimbursed{get;set;}

    //Other Dependents details
    public String otherFirstName{get;set;}
    public String otherMiddleName{get;set;}
    public String otherLastName{get;set;}
    public String otherRelationship{get;set;}
    public Date otherdob{get;set;}
    public String otherssn{get;set;}
    public String otherVisaStatus{get;set;}
    public Date otherFirstPortEntry{get;set;}
    public Integer othernoofdays{get;set;}

    public String otherDependentName{get;set;}
    public String otherInstitutionName{get;set;}
    public String otherInsFedId{get;set;}
    public String otherInsAddress{get;set;}
    public Integer otherAmount{get;set;}
    public Integer otherAmountReimbursed{get;set;}

    //Bank and residency details
    public String accountName{get;set;}
    public String bankName{get;set;}
    public String bankRouting{get;set;}
    public Integer accountNumber{get;set;}
    public String accountType{get;set;}

    public Boolean residencyDetails{get;set;}
    public Boolean resCurrentYear{get;set;}
    public Boolean resCurrentYearMinus1{get;set;}
    public Boolean resCurrentYearMinus2{get;set;}

    public String currentStatesResided{get;set;}
    public Date currentStayStartDate{get;set;}
    public Date currentStayEndDate{get;set;}
    public String currentMinus1StatesResided{get;set;}
    public Date currentMinus1StayStartDate{get;set;}
    public Date currentMinus1StayEndDate{get;set;}
    public String currentMinus2StatesResided{get;set;}
    public Date currentMinus2StayStartDate{get;set;}
    public Date currentMinus2StayEndDate{get;set;}

    //Itemized Deductions 
    public Integer mipAmount{get;set;}
    public Integer pdAmount{get;set;}
    public Integer glassAmount{get;set;}
    public Integer hospitalChargesAmount{get;set;}
    public Integer doctorAmount{get;set;}
    public Integer maternityAmount{get;set;}
    public Integer milesAmount{get;set;}

    public Integer realEstatePrimaryRes{get;set;}
    public Integer realEstateSecondaryRes{get;set;}
    public Integer personalPropertyTax{get;set;}
    public Integer stateTaxReturnTax{get;set;}

    public Integer primaryHomeMortgageInterest{get;set;}
    public Integer primaryHomeMortgageIntPaid{get;set;}
    public Integer primaryMortgageInsPaid{get;set;}
    public Integer secondaryHomeMortgageInterest{get;set;}
    public Integer secondaryHomeMortgageIntPaid{get;set;}
    public Integer secondaryMortgageInsPaid{get;set;}
    public String commentsToPreparer{get;set;}

    public String educatorExpense{get;set;}
    public String hsaContribution{get;set;}
    public String penaltyEarlyWithdrawlSaving{get;set;}
    public String alimonyPaid{get;set;}
    public String receipientssn{get;set;}
    public String iraContribution{get;set;}
    public String studentLoan{get;set;}
    public String higherEdTutionFee{get;set;}

    public String moreThan10000{get;set;}
    public String moreThan50000{get;set;}
    public String hasRentalIncome{get;set;}
    public String hasBusinessIncome{get;set;}
    public String hasIOWAIncome{get;set;}
    public String hasMassachusetts{get;set;}
    public String casualtyTheftLoses{get;set;}
    public String estimatedTax{get;set;}

    public String notes{get;set;}

    public String filename{get;set;}
    public List<String> filenameList{get;set;}

    public String currentYear{get;set;} 
    public String currentYear_1{get;set;}
    public String currentYear_2{get;set;}
    public String currentYearPlus1{get;set;}

    public List<ForeignBankDetails> bankDetails{get;set;}

    public Boolean uploadNow{get;set;}
    public Boolean uploadLater{get;set;}
}