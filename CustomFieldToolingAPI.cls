public class CustomFieldToolingAPI{
    public String Id {get;set;}// "00N9000000EaE1bEAF",
    //public String TableEnumOrId {get;set;}// "01I90000001bnvREAQ",
    //public String DeveloperName {get;set;}// "Project_Phase",
    //public String Description {get;set;}// null,
    /*
    public String Length {get;set;}// null,
    public String Precision {get;set;}// null,
    public String Scale {get;set;}// //null,
    public String DefaultValue {get;set;}// null,
    public String RelationshipLabel {get;set;}// null,
    public String SummaryOperation {get;set;}// null,
    public String InlineHelpText {get;set;}// null,
    public String MaskType {get;set;}// null,
    public String MaskChar {get;set;}// null,
    public String NamespacePrefix {get;set;}// null,
    public String ManageableState {get;set;}// "unmanaged",
    public String CreatedDate {get;set;}// "2015-12-10T15:30:09.000+0000",
    public String CreatedById {get;set;}// "00590000002wjSyAAI",
    public String LastModifiedDate {get;set;}// "2015-12-10T15:30:09.000+0000",
    public String LastModifiedById {get;set;}// "00590000002wjSyAAI",
    public String EntityDefinitionId {get;set;}// "01I90000001bnvR",
    */
    public String FullName {get;set;}// "Project__c.Project_Phase__c"
    //public String type {get;set;}
    public CustomFieldToolingAPI.MetadataJSON Metadata {get;set;}//

    public Class MetadataJSON {
        /*
        public String caseSensitive {get;set;}// null,
        public String customDataType {get;set;}// null,
        public String defaultValue {get;set;}// null,
        public String deleteConstraint {get;set;}// null,
        public String deprecated {get;set;}// null,
        public String description {get;set;}// null,
        public String displayFormat {get;set;}// null,
        public String displayLocationInDecimal {get;set;}// null,
        public String encrypted {get;set;}// null,
        public String escapeMarkup {get;set;}// null,
        public String externalDeveloperName {get;set;}// null,
        public String externalId {get;set;}// false,
        public String formula {get;set;}// null,
        public String formulaTreatBlanksAs {get;set;}// null,
        public String globalPicklist {get;set;}// null,
        public String inlineHelpText {get;set;}// null,
        public String isConvertLeadDisabled {get;set;}// null,
        public String isFilteringDisabled {get;set;}// null,
        public String isNameField {get;set;}// null,
        public String isSortingDisabled {get;set;}// null,
        public String label {get;set;}// "Project Phase",
        public String length {get;set;}// null,
        public String lookupFilter {get;set;}// null,
        public String maskChar {get;set;}// null,
        public String maskType {get;set;}// null,
        //-----------------------------------------//
        //picklist value deleted
        //-----------------------------------------//
        public String populateExistingRows {get;set;}// null,
        public String precision {get;set;}// null,
        public String readOnlyProxy {get;set;}// null,
        public String referenceTargetField {get;set;}// null,
        public String referenceTo {get;set;}// null,
        public String relationshipLabel {get;set;}// null,
        public String relationshipName {get;set;}// null,
        public String relationshipOrder {get;set;}// null,
        public String reparentableMasterDetail {get;set;}// null,
        public String required {get;set;}// null,
        public String restrictedAdminField {get;set;}// null,
        public String scale {get;set;}// null,
        public String startingNumber {get;set;}// null,
        public String stripMarkup {get;set;}// null,
        public String summarizedField {get;set;}// null,
        public String summaryForeignKey {get;set;}// null,
        public String summaryOperation {get;set;}// null,
        public String trackFeedHistory {get;set;}// null,
        public String trackHistory {get;set;}// null,
        public String trackTrending {get;set;}// false,
        */
        public String type {get;set;}// "Picklist",
        public String label {get;set;}
        public String defaultValue {get;set;}
        //public String unique {get;set;}// null,
        //public String urls {get;set;}// null,
        //public String visibleLines {get;set;}// null,
        //public String writeRequiresMasterRead {get;set;}// null
    }

}