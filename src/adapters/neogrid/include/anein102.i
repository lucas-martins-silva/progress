{adapters/neogrid/include/anein101.i}

/*********************************************************************/
/*  MQPMO Structure -- Put Message Options                           */
/*********************************************************************/
DEFINE TEMP-TABLE TT_MQPMO
    FIELD StrucId            AS CHARACTER INIT {&MQPMO_STRUC_ID}   /* Structure identifier */
    FIELD Version            AS INTEGER   INIT {&MQPMO_VERSION_1}        /* Structure version number */
    FIELD Options            AS INTEGER   INIT {&MQPMO_NONE}        /* Options that control the action of MQPUT or MQPUT1 */
    FIELD Timeout            AS INTEGER   INIT -1        /* Reserved */
    FIELD Context            AS INTEGER   INIT 0        /* Object handle of input queue */
    FIELD KnownDestCount     AS INTEGER   INIT 0        /* Number of messages sent successfully to local queues */
    FIELD UnknownDestCount   AS INTEGER   INIT 0        /* Number of messages sent successfully to remote queues */
    FIELD InvalidDestCount   AS INTEGER   INIT 0        /* Number of messages that could not be sent */
    FIELD ResolvedQName      AS CHARACTER INIT ""       /* Resolved name of destination queue */
    FIELD ResolvedQMgrName   AS CHARACTER INIT ""       /* Resolved name of destination queue manager */
    FIELD RecsPresent        AS INTEGER   INIT 0        /* Number of put message records or response records present */
    FIELD PutMsgRecFields    AS INTEGER   INIT {&MQPMRF_NONE}        /* Flags indicating which MQPMR fields are present */
    FIELD PutMsgRecOffset    AS INTEGER   INIT 0        /* Offset of first put message record from start of MQPMO */
    FIELD ResponseRecOffset  AS INTEGER   INIT 0        /* Offset of first response record from start of MQPMO */
    FIELD PutMsgRecPtr       AS INTEGER   INIT 0        /* Address of first put message record */
    FIELD ResponseRecPtr     AS INTEGER   INIT 0        /* Address of first response record */
    index ch-id is primary StrucId.


/*********************************************************************/
/*  MQGMO Structure -- Get Message Options                           */
/*********************************************************************/
DEFINE TEMP-TABLE TT_MQGMO
    FIELD StrucId           AS CHARACTER    INIT {&MQGMO_STRUC_ID}      /* Structure identifier */
    FIELD Version           AS INTEGER      INIT {&MQGMO_VERSION_1}     /* Structure version number */
    FIELD Options           AS INTEGER      INIT {&MQGMO_NO_WAIT}       /* Options that control the action of MQGET */
    FIELD WaitInterval      AS INTEGER      INIT 0                      /* Wait interval */
    FIELD Signal1           AS INTEGER      INIT 0                      /* Signal */
    FIELD Signal2           AS INTEGER      INIT 0                      /* Signal identifier */
    FIELD ResolvedQName     AS CHARACTER    INIT ""                     /* Resolved name of destination queue */
    FIELD MatchOptions      AS INTEGER      INIT 3                      /* Options controlling selection criteria used for MQGET */
                                              /* {&MQMO_MATCH_MSG_ID} + {&MQMO_MATCH_CORREL_ID} */
    FIELD GroupStatus       AS CHARACTER    INIT {&MQGS_NOT_IN_GROUP}   /* Flag indicating whether message retrieved is in a group */
    FIELD SegmentStatus     AS CHARACTER    INIT {&MQSS_NOT_A_SEGMENT}  /* Flag indicating whether message retrieved is a segment of a logical message */
    FIELD Segmentation      AS CHARACTER    INIT {&MQSEG_INHIBITED}     /* Flag indicating whether segmentation is allowed for the message retrieved */
    FIELD Reserved1         AS CHARACTER    INIT " "                    /* Reserved */
    index ch-id is primary StrucId.


/*********************************************************************/
/*  MQOD Structure -- Object Descriptor                              */
/*********************************************************************/
DEFINE TEMP-TABLE TT_MQOD
    FIELD StructId          AS CHARACTER    INIT {&MQOD_STRUC_ID}     /* Structure identifier */
    FIELD Version           AS INTEGER      INIT {&MQOD_VERSION_2}    /* Structure version number */
    FIELD ObjectType        AS INTEGER      INIT 1          /* Object type */
    FIELD ObjectName        AS CHARACTER    INIT ""         /* Object name */
    FIELD ObjectQMgrName    AS CHARACTER    INIT ""         /* Object queue manager name */
    FIELD DynamicQName      AS CHARACTER    INIT "" /*"AMQ.*"*/    /* Dynamic queue name */
    FIELD AlternateUserId   AS CHARACTER    INIT ""         /* Alternate user identifier */
    FIELD RecsPresent       AS INTEGER      INIT 0          /* Number of object records present */
    FIELD KnownDestCount    AS INTEGER      INIT 0          /* Number of local queues opened successfully */
    FIELD UnknownDestCount  AS INTEGER      INIT 0          /* Number of remote queues opened successfully */
    FIELD InvalidDestCount  AS INTEGER      INIT 0          /* Number of queues that failed to open */
    FIELD ObjectRecOffset   AS INTEGER      INIT 0          /* Offset of first object record from start of MQOD */
    FIELD ResponseRecOffset AS INTEGER      INIT 0          /* Offset of first response record from start of MQOD */
    FIELD ObjectRecPtr      AS INTEGER      INIT 0          /* Address of first object record */
    FIELD ResponseRecPtr    AS INTEGER      INIT 0          /* Address of first response record */
    index ch-id is primary StructId.

/*********************************************************************/
/*  MQMD Structure -- Message Descriptor                             */
/*********************************************************************/
DEFINE TEMP-TABLE TT_MQMD
    FIELD StrucId           AS CHARACTER    INIT {&MQMD_STRUC_ID}   /* Structure identifier */
    FIELD Version           AS INTEGER      INIT {&MQMD_VERSION_1}  /* Structure version number */
    FIELD Report            AS INTEGER      INIT {&MQRO_NONE}       /* Report options */
    FIELD MsgType           AS INTEGER      INIT {&MQMT_DATAGRAM}   /* Message type */
    FIELD Expiry            AS INTEGER      INIT {&MQEI_UNLIMITED}  /* Expiry time */
    FIELD Feedback          AS INTEGER      INIT {&MQFB_NONE}       /* Feedback or reason code */
    FIELD Encoding          AS INTEGER      INIT {&MQENC_NATIVE}    /* Data encoding */
    FIELD CodedCharSetId    AS INTEGER      INIT {&MQCCSI_Q_MGR}    /* Coded character set identifier */
    FIELD FFormat           AS CHARACTER    INIT {&MQFMT_NONE}      /* Format name */
    FIELD Priority          AS INTEGER      INIT {&MQPRI_PRIORITY_AS_Q_DEF}     /* Message priority */
    FIELD Persistence       AS INTEGER      INIT {&MQPER_PERSISTENCE_AS_Q_DEF}  /* Message persistence */
    FIELD MsgId             AS CHARACTER    INIT {&MQMI_NONE}       /* Message identifier */
    FIELD CorrelId          AS CHARACTER    INIT {&MQCI_NONE}       /* Correlation identifier */
    FIELD BackoutCount      AS INTEGER      INIT 0                  /* Backout counter */
    FIELD ReplyToQ          AS CHARACTER    INIT ""                 /* Name of reply-to queue */
    FIELD ReplyToQMgr       AS CHARACTER    INIT ""                 /* Name of reply queue manager */
    FIELD UserIdentifier    AS CHARACTER    INIT ""                 /* User identifier */
    FIELD AccountingToken   AS CHARACTER    INIT {&MQACT_NONE}      /* Accounting token */
    FIELD ApplIdentityData  AS CHARACTER    INIT ""                 /* Application data relating to identity */
    FIELD PutApplType       AS INTEGER      INIT {&MQAT_NO_CONTEXT} /* Type of application that put the message */
    FIELD PutApplName       AS CHARACTER    INIT ""                 /* Name of application that put the message */
    FIELD PutDate           AS CHARACTER    INIT ""                 /* Date when message was put */
    FIELD PutTime           AS CHARACTER    INIT ""                 /* Time when message was put */
    FIELD ApplOriginData    AS CHARACTER    INIT ""                 /* Application data relating to origin */
    FIELD GroupId           AS CHARACTER    INIT {&MQGI_NONE}       /* Group identifier */
    FIELD MsgSeqNumber      AS INTEGER      INIT 1                  /* Sequence number of logical message within group */
    FIELD Offset            AS INTEGER      INIT 0                  /* Offset of data in physical message from start of logical message */
    FIELD MsgFlags          AS INTEGER      INIT {&MQMF_NONE}       /* Message flags */
    FIELD OriginalLength    AS INTEGER      INIT {&MQOL_UNDEFINED}  /* Length of original message */
    index ch-id is primary StrucId.

/*********************************************************************/
/*  MQBO Structure -- Begin Options                                  */
/*********************************************************************/
DEFINE TEMP-TABLE TT_MQBO
    FIELD StrucId   AS CHARACTER    INIT {&MQBO_STRUC_ID}       /* Structure identifier */
    FIELD Version   AS INTEGER      INIT {&MQBO_VERSION_1}      /* Structure version number */
    FIELD Options   AS INTEGER      INIT {&MQBO_NONE}           /* Options that control the action of MQBEGIN */
    index ch-id is primary StrucId.
