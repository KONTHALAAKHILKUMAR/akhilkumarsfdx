public class FileUploadController {
    public Boolean showUpload{get;set;}
    public Boolean editMode{get;set;}
    public String fileName{get;set;}
    public List<AttachmentMeta> filenameList{get;set;}
    public List<String> fileNames{get;set;}
    public Blob fileBody{get;set;}
    public String attachId{get;set;}
    public String taxIdFromBack{get;set;}
    public String downloadUrl{get;set;}

    public TaxationController temp{
        get{
            if(temp == null){
                temp = new TaxationController();
            }
            return temp;
        }
        set;}

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
    public Pagereference myMethod(){
        System.debug('@@taxIdFromBack'+taxIdFromBack);
        return null;
    }
    public FileUploadController(){
        showUpload = false;
        editMode = true;
        filenameList = new List<AttachmentMeta>();
        fileNames = new List<String>();
        System.debug('@@'+temp.taxId);
        System.debug('@@'+temp.editMode);
        taxIdFromBack = temp.taxId;
        downloadUrl = 'https://'+Url.getSalesforceBaseUrl().getHost().split('--c.visualforce.com')[0];
        downloadUrl += '--c.documentforce.com/servlet/servlet.FileDownload?file=';
        addDatainList();
    }
    public Boolean getShowFileUploadSection(){
        return filenameList.size() > 0 ? true : false;
    }
    public Pagereference addFile(){
        showUpload = true;
        return null;
        //return addDatainList();
    }
    public Pagereference updateData(){
        return null;
    }
    public Pagereference addDatainList(){
        System.debug('@@came to upload');
        filenameList = new List<AttachmentMeta>();
        //fileNames = new List<String>();
        for(Attachment att : [SELECT Id,Name,Description FROM Attachment WHERE ParentId=:taxIdFromBack]){
            AttachmentMeta am = new AttachmentMeta();
            am.fileName = att.Description;
            am.fileValue = att.Name;
            am.fileId = att.Id;
            filenameList.add(am);
            //fileNames.add(att.Name);
        }
        showUpload = false;
        fileName = '';
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