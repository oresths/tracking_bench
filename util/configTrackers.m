function trackers=configTrackers

trackersVIVID={struct('name','VR','namePaper','VR-V'),...%gray-25%
    struct('name','TM','namePaper','TM-V'),...%dark red
    struct('name','RS','namePaper','RS-V'),...%orange
    struct('name','PD','namePaper','PD-V'),...%Turquoise
    struct('name','MS','namePaper','MS-V')%purple
};

trackers1={struct('name','CT','namePaper','CT'),...
    struct('name','TLD','namePaper','TLD'),...    
    struct('name','IVT','namePaper','IVT'),...
    struct('name','DFT','namePaper','DFT'),...%yellow
    struct('name','ASLA','namePaper','ASLA'),...
    struct('name','L1APG','namePaper','L1APG'),...    
    struct('name','ORIA','namePaper','ORIA'),...
    struct('name','MTT','namePaper','MTT'),...
    struct('name','CSK','namePaper','CSK'),...
    struct('name','SCM','namePaper','SCM'),...
    struct('name','LOT','namePaper','LOT')};

trackersEXE={ struct('name','CPF','namePaper','CPF'),...
    struct('name','Struck','namePaper','Struck'),...
    struct('name','MIL','namePaper','MIL'),...
    struct('name','OAB','namePaper','OAB'),...
    struct('name','SBT','namePaper','SemiT'),...
    struct('name','BSBT','namePaper','BSBT'),...
    struct('name','Frag','namePaper','Frag'),...
    struct('name','KMS','namePaper','KMS'),...
    struct('name','SMS','namePaper','SMS'),...
    struct('name','LSK','namePaper','LSK'),...
    struct('name','VTS','namePaper','VTS'),...
    struct('name','VTD','namePaper','VTD'),...
    struct('name','CXT','namePaper','CXT')};

trackersECCV = { ...
%         struct('name','ASLA','namePaper','ASLA'),....
%         struct('name','CSK','namePaper','CSK'),...
%         struct('name','KCF_LinearHog','namePaper','DCF'),...
        struct('name','DSST','namePaper','DSST'),...
% %         struct('name','IVT','namePaper','IVT'),...
%         struct('name','KCF_GaussHog','namePaper','KCF'),...
%         struct('name','MEEM','namePaper','MEEM'),...
%         struct('name','KCF_LinearGray','namePaper','MOSSE'),...
%         struct('name','MUSTER','namePaper','MUSTER'),...
% %         struct('name','OAB','namePaper','OAB'),...
%         struct('name','SAMF','namePaper','SAMF'),...
        struct('name','SRDCF','namePaper','SRDCF'),...
%         struct('name','Struck','namePaper','Struck'),...
% %         struct('name','TLD','namePaper','TLD')...
}; 

trackersCVPR = { ...
%         struct('name','DSST','namePaper','DSST'),...
%         struct('name','FDSST','namePaper','FDSST'),...
%         struct('name','StapleP','namePaper','STAPLE_plus'),...
%         struct('name','SSKCF','namePaper','SSKCF'),...
%         struct('name','Struck','namePaper','Struck'),...
%         struct('name','NSAMF','namePaper','NSAMF'),...
%         struct('name','DAT','namePaper','DAT'),...
        struct('name','MEEM','namePaper','MEEM'),...
%         struct('name','SRDCF','namePaper','SRDCF')
}; 
    
%trackers = [trackersVIVID,trackers1,trackersEXE];
trackers = trackersCVPR;