&IF NOT DEFINED(MQSPREPR) > 0 &THEN
&GLOBAL-DEFINE MQSPREPR     DEFINED


/*********************************************************************/
/*  Values Related to MQOPEN Function                                */
/*********************************************************************/
/* Open Options */
&GLOBAL-DEFINE MQOO_INPUT_AS_Q_DEF           1
&GLOBAL-DEFINE MQOO_INPUT_SHARED             2
&GLOBAL-DEFINE MQOO_INPUT_EXCLUSIVE          4
&GLOBAL-DEFINE MQOO_BROWSE                   8
&GLOBAL-DEFINE MQOO_OUTPUT                   16
&GLOBAL-DEFINE MQOO_INQUIRE                  32
&GLOBAL-DEFINE MQOO_SET                      64
&GLOBAL-DEFINE MQOO_SAVE_ALL_CONTEXT         128
&GLOBAL-DEFINE MQOO_PASS_IDENTITY_CONTEXT    256
&GLOBAL-DEFINE MQOO_PASS_ALL_CONTEXT         512
&GLOBAL-DEFINE MQOO_SET_IDENTITY_CONTEXT     1024
&GLOBAL-DEFINE MQOO_SET_ALL_CONTEXT          2048
&GLOBAL-DEFINE MQOO_ALTERNATE_USER_AUTHORITY 4096
&GLOBAL-DEFINE MQOO_FAIL_IF_QUIESCING        8192


/*********************************************************************/
/*  MQPMO Structure -- Put Message Options                           */
/*********************************************************************/
&GLOBAL-DEFINE MQPMO_StrucId            1   /* Structure identifier */
&GLOBAL-DEFINE MQPMO_Version            5   /* Structure version number */
&GLOBAL-DEFINE MQPMO_Options            9   /* Options that control the action of MQPUT or MQPUT1 */
&GLOBAL-DEFINE MQPMO_Timeout            13  /* Reserved */
&GLOBAL-DEFINE MQPMO_Context            17  /* Object handle of input queue */
&GLOBAL-DEFINE MQPMO_KnownDestCount     21  /* Number of messages sent successfully to local queues */
&GLOBAL-DEFINE MQPMO_UnknownDestCount   25  /* Number of messages sent successfully to remote queues */
&GLOBAL-DEFINE MQPMO_InvalidDestCount   29  /* Number of messages that could not be sent */
&GLOBAL-DEFINE MQPMO_ResolvedQName      33  /* Resolved name of destination queue */
&GLOBAL-DEFINE MQPMO_ResolvedQMgrName   81  /* Resolved name of destination queue manager */
&GLOBAL-DEFINE MQPMO_RecsPresent        129 /* Number of put message records or response records present */
&GLOBAL-DEFINE MQPMO_PutMsgRecFields    133 /* Flags indicating which MQPMR fields are present */
&GLOBAL-DEFINE MQPMO_PutMsgRecOffset    137 /* Offset of first put message record from start of MQPMO */
&GLOBAL-DEFINE MQPMO_ResponseRecOffset  141 /* Offset of first response record from start of MQPMO */
&GLOBAL-DEFINE MQPMO_PutMsgRecPtr       145 /* Address of first put message record */
&GLOBAL-DEFINE MQPMO_ResponseRecPtr     149 /* Address of first response record */

/*********************************************************************/
/*  Values Related to MQPMO Structure                                */
/*********************************************************************/
/* Structure Identifier */
&GLOBAL-DEFINE MQPMO_STRUC_ID "PMO "
   
/* Structure Version Number */
&GLOBAL-DEFINE MQPMO_VERSION_1       1
&GLOBAL-DEFINE MQPMO_VERSION_2       2
&GLOBAL-DEFINE MQPMO_CURRENT_VERSION 2
   
/* Structure Length */
&GLOBAL-DEFINE MQPMO_CURRENT_LENGTH 152
   
/* Put-Message Options */
&GLOBAL-DEFINE MQPMO_SYNCPOINT                2
&GLOBAL-DEFINE MQPMO_NO_SYNCPOINT             4
&GLOBAL-DEFINE MQPMO_NEW_MSG_ID               64
&GLOBAL-DEFINE MQPMO_NEW_CORREL_ID            128
&GLOBAL-DEFINE MQPMO_LOGICAL_ORDER            32768
&GLOBAL-DEFINE MQPMO_NO_CONTEXT               16384
&GLOBAL-DEFINE MQPMO_DEFAULT_CONTEXT          32
&GLOBAL-DEFINE MQPMO_PASS_IDENTITY_CONTEXT    256
&GLOBAL-DEFINE MQPMO_PASS_ALL_CONTEXT         512
&GLOBAL-DEFINE MQPMO_SET_IDENTITY_CONTEXT     1024
&GLOBAL-DEFINE MQPMO_SET_ALL_CONTEXT          2048
&GLOBAL-DEFINE MQPMO_ALTERNATE_USER_AUTHORITY 4096
&GLOBAL-DEFINE MQPMO_FAIL_IF_QUIESCING        8192
&GLOBAL-DEFINE MQPMO_NONE                     0
   
/* Put Message Record Fields */
&GLOBAL-DEFINE MQPMRF_MSG_ID           1
&GLOBAL-DEFINE MQPMRF_CORREL_ID        2
&GLOBAL-DEFINE MQPMRF_GROUP_ID         4
&GLOBAL-DEFINE MQPMRF_FEEDBACK         8
&GLOBAL-DEFINE MQPMRF_ACCOUNTING_TOKEN 16
&GLOBAL-DEFINE MQPMRF_NONE             0


/*********************************************************************/
/*  MQGMO Structure -- Get Message Options                           */
/*********************************************************************/
&GLOBAL-DEFINE MQGMO_StrucId            1   /* Structure identifier */
&GLOBAL-DEFINE MQGMO_Version            5   /* Structure version number */
&GLOBAL-DEFINE MQGMO_Options            9   /* Options that control the action of MQGET */
&GLOBAL-DEFINE MQGMO_WaitInterval       13  /* Wait interval */
&GLOBAL-DEFINE MQGMO_Signal1            17  /* Signal */
&GLOBAL-DEFINE MQGMO_Signal2            21  /* Signal identifier */
&GLOBAL-DEFINE MQGMO_ResolvedQName      25  /* Resolved name of destination queue */
&GLOBAL-DEFINE MQGMO_MatchOptions       73  /* Options controlling selection criteria used for MQGET */
&GLOBAL-DEFINE MQGMO_GroupStatus        77  /* Flag indicating whether message retrieved is in a group */
&GLOBAL-DEFINE MQGMO_SegmentStatus      78  /* Flag indicating whether message retrieved is a segment of a logical message */
&GLOBAL-DEFINE MQGMO_Segmentation       79  /* Flag indicating whether segmentation is allowed for the message retrieved */
&GLOBAL-DEFINE MQGMO_Reserved1          80  /* Reserved */

&GLOBAL-DEFINE MQGMO_CURRENT_LENGTH     81

/*********************************************************************/
/*  Values Related to MQGMO Structure                                */
/*********************************************************************/
/* Structure Identifier */
&GLOBAL-DEFINE MQGMO_STRUC_ID "GMO "

/* Structure Version Number */
&GLOBAL-DEFINE MQGMO_VERSION_1       1
&GLOBAL-DEFINE MQGMO_VERSION_2       2
&GLOBAL-DEFINE MQGMO_CURRENT_VERSION 2

/* Get-Message Options */
&GLOBAL-DEFINE MQGMO_WAIT                    1
&GLOBAL-DEFINE MQGMO_NO_WAIT                 0
&GLOBAL-DEFINE MQGMO_SYNCPOINT               2
&GLOBAL-DEFINE MQGMO_SYNCPOINT_IF_PERSISTENT 4096
&GLOBAL-DEFINE MQGMO_NO_SYNCPOINT            4
&GLOBAL-DEFINE MQGMO_MARK_SKIP_BACKOUT       128
&GLOBAL-DEFINE MQGMO_BROWSE_FIRST            16
&GLOBAL-DEFINE MQGMO_BROWSE_NEXT             32
&GLOBAL-DEFINE MQGMO_BROWSE_MSG_UNDER_CURSOR 2048
&GLOBAL-DEFINE MQGMO_MSG_UNDER_CURSOR        256
&GLOBAL-DEFINE MQGMO_LOCK                    512
&GLOBAL-DEFINE MQGMO_UNLOCK                  1024
&GLOBAL-DEFINE MQGMO_ACCEPT_TRUNCATED_MSG    64
&GLOBAL-DEFINE MQGMO_SET_SIGNAL              8L
&GLOBAL-DEFINE MQGMO_FAIL_IF_QUIESCING       8192
&GLOBAL-DEFINE MQGMO_CONVERT                 16384
&GLOBAL-DEFINE MQGMO_LOGICAL_ORDER           32768
&GLOBAL-DEFINE MQGMO_COMPLETE_MSG            65536
&GLOBAL-DEFINE MQGMO_ALL_MSGS_AVAILABLE      131072
&GLOBAL-DEFINE MQGMO_ALL_SEGMENTS_AVAILABLE  262144
&GLOBAL-DEFINE MQGMO_NONE                    0

/* Wait Interval */
&GLOBAL-DEFINE MQWI_UNLIMITED (-1L)
   
/* Signal Values */
&GLOBAL-DEFINE MQEC_MSG_ARRIVED           2
&GLOBAL-DEFINE MQEC_WAIT_INTERVAL_EXPIRED 3
&GLOBAL-DEFINE MQEC_WAIT_CANCELED         4
&GLOBAL-DEFINE MQEC_Q_MGR_QUIESCING       5
&GLOBAL-DEFINE MQEC_CONNECTION_QUIESCING  6
   
/* Match Options */
&GLOBAL-DEFINE MQMO_MATCH_MSG_ID         1
&GLOBAL-DEFINE MQMO_MATCH_CORREL_ID      2
&GLOBAL-DEFINE MQMO_MATCH_GROUP_ID       4
&GLOBAL-DEFINE MQMO_MATCH_MSG_SEQ_NUMBER 8
&GLOBAL-DEFINE MQMO_MATCH_OFFSET         16
&GLOBAL-DEFINE MQMO_NONE                 0
   
/* Group Status */
&GLOBAL-DEFINE MQGS_NOT_IN_GROUP      ' '
&GLOBAL-DEFINE MQGS_MSG_IN_GROUP      'G'
&GLOBAL-DEFINE MQGS_LAST_MSG_IN_GROUP 'L'
   
/* Segment Status */
&GLOBAL-DEFINE MQSS_NOT_A_SEGMENT ' '
&GLOBAL-DEFINE MQSS_SEGMENT       'S'
&GLOBAL-DEFINE MQSS_LAST_SEGMENT  'L'
   
/* Segmentation */
&GLOBAL-DEFINE MQSEG_INHIBITED ' '
&GLOBAL-DEFINE MQSEG_ALLOWED   'A'


/*********************************************************************/
/*  Values Related to MQCLOSE Function                               */
/*********************************************************************/
/* Object Handle */
&GLOBAL-DEFINE MQHO_UNUSABLE_HOBJ -1
/* Close Options */
&GLOBAL-DEFINE MQCO_NONE         0
&GLOBAL-DEFINE MQCO_DELETE       1
&GLOBAL-DEFINE MQCO_DELETE_PURGE 2




/*********************************************************************/
/*  MQOD Structure -- Object Descriptor                              */
/*********************************************************************/
&GLOBAL-DEFINE MQOD_StructId            1   /* Structure identifier */
&GLOBAL-DEFINE MQOD_Version             5   /* Structure version number */
&GLOBAL-DEFINE MQOD_ObjectType          9   /* Object type */
&GLOBAL-DEFINE MQOD_ObjectName          13  /* Object name */
&GLOBAL-DEFINE MQOD_ObjectQMgrName      61  /* Object queue manager name */
&GLOBAL-DEFINE MQOD_DynamicQName        109 /* Dynamic queue name */
&GLOBAL-DEFINE MQOD_AlternateUserId     157 /* Alternate user identifier */
&GLOBAL-DEFINE MQOD_RecsPresent         169 /* Number of object records present */
&GLOBAL-DEFINE MQOD_KnownDestCount      173 /* Number of local queues opened successfully */
&GLOBAL-DEFINE MQOD_UnknownDestCount    177 /* Number of remote queues opened successfully */
&GLOBAL-DEFINE MQOD_InvalidDestCount    181 /* Number of queues that failed to open */
&GLOBAL-DEFINE MQOD_ObjectRecOffset     185 /* Offset of first object record from start of MQOD */
&GLOBAL-DEFINE MQOD_ResponseRecOffset   189 /* Offset of first response record from start of MQOD */
&GLOBAL-DEFINE MQOD_ObjectRecPtr        193 /* Address of first object record */
&GLOBAL-DEFINE MQOD_ResponseRecPtr      197 /* Address of first response record */

/*********************************************************************/
/*  Values Related to MQOD Structure                                 */
/*********************************************************************/

/* Structure Identifier */
&GLOBAL-DEFINE MQOD_STRUC_ID "OD  "

/* Structure Version Number */
&GLOBAL-DEFINE MQOD_VERSION_1       1
&GLOBAL-DEFINE MQOD_VERSION_2       2
&GLOBAL-DEFINE MQOD_CURRENT_VERSION 2

/* Structure Length */
&GLOBAL-DEFINE MQOD_CURRENT_LENGTH      200

/* Object Types */
&GLOBAL-DEFINE MQOT_Q          1
&GLOBAL-DEFINE MQOT_NAMELIST   2
&GLOBAL-DEFINE MQOT_PROCESS    3
&GLOBAL-DEFINE MQOT_Q_MGR      5
&GLOBAL-DEFINE MQOT_CHANNEL    6
&GLOBAL-DEFINE MQOT_RESERVED_1 7


/*********************************************************************/
/*  MQMD Structure -- Message Descriptor                             */
/*********************************************************************/
&GLOBAL-DEFINE MQMD_StrucId             1   /* Structure identifier */
&GLOBAL-DEFINE MQMD_Version             5   /* Structure version number */
&GLOBAL-DEFINE MQMD_Report              9   /* Report options */
&GLOBAL-DEFINE MQMD_MsgType             13  /* Message type */
&GLOBAL-DEFINE MQMD_Expiry              17  /* Expiry time */
&GLOBAL-DEFINE MQMD_Feedback            21  /* Feedback or reason code */
&GLOBAL-DEFINE MQMD_Encoding            25  /* Data encoding */
&GLOBAL-DEFINE MQMD_CodedCharSetId      29  /* Coded character set identifier */
&GLOBAL-DEFINE MQMD_Format              33  /* Format name */
&GLOBAL-DEFINE MQMD_Priority            41  /* Message priority */
&GLOBAL-DEFINE MQMD_Persistence         45  /* Message persistence */
&GLOBAL-DEFINE MQMD_MsgId               49  /* Message identifier */
&GLOBAL-DEFINE MQMD_CorrelId            73  /* Correlation identifier */
&GLOBAL-DEFINE MQMD_BackoutCount        97  /* Backout counter */
&GLOBAL-DEFINE MQMD_ReplyToQ            101 /* Name of reply-to queue */
&GLOBAL-DEFINE MQMD_ReplyToQMgr         149 /* Name of reply queue manager */
&GLOBAL-DEFINE MQMD_UserIdentifier      197 /* User identifier */
&GLOBAL-DEFINE MQMD_AccountingToken     209 /* Accounting token */
&GLOBAL-DEFINE MQMD_ApplIdentityData    241 /* Application data relating to identity */
&GLOBAL-DEFINE MQMD_PutApplType         273 /* Type of application that put the message */
&GLOBAL-DEFINE MQMD_PutApplName         277 /* Name of application that put the message */
&GLOBAL-DEFINE MQMD_PutDate             305 /* Date when message was put */
&GLOBAL-DEFINE MQMD_PutTime             313 /* Time when message was put */
&GLOBAL-DEFINE MQMD_ApplOriginData      321 /* Application data relating to origin */
&GLOBAL-DEFINE MQMD_GroupId             325 /* Group identifier */
&GLOBAL-DEFINE MQMD_MsgSeqNumber        349 /* Sequence number of logical message within group */
&GLOBAL-DEFINE MQMD_Offset              353 /* Offset of data in physical message from start of logical message */
&GLOBAL-DEFINE MQMD_MsgFlags            357 /* Message flags */
&GLOBAL-DEFINE MQMD_OriginalLength      361 /* Length of original message */

/*********************************************************************/
/*  Values Related to MQMD Structure                                 */
/*********************************************************************/
/* Structure Identifier */
&GLOBAL-DEFINE MQMD_STRUC_ID "MD  "
   
/* Structure Version Number */
&GLOBAL-DEFINE MQMD_VERSION_1       1
&GLOBAL-DEFINE MQMD_VERSION_2       2
&GLOBAL-DEFINE MQMD_CURRENT_VERSION 2

/* Report Options */
&GLOBAL-DEFINE MQRO_EXCEPTION                 16777216
&GLOBAL-DEFINE MQRO_EXCEPTION_WITH_DATA       50331648
&GLOBAL-DEFINE MQRO_EXCEPTION_WITH_FULL_DATA  117440512
&GLOBAL-DEFINE MQRO_EXPIRATION                2097152
&GLOBAL-DEFINE MQRO_EXPIRATION_WITH_DATA      6291456
&GLOBAL-DEFINE MQRO_EXPIRATION_WITH_FULL_DATA 14680064
&GLOBAL-DEFINE MQRO_COA                       256
&GLOBAL-DEFINE MQRO_COA_WITH_DATA             768
&GLOBAL-DEFINE MQRO_COA_WITH_FULL_DATA        1792
&GLOBAL-DEFINE MQRO_COD                       2048
&GLOBAL-DEFINE MQRO_COD_WITH_DATA             6144
&GLOBAL-DEFINE MQRO_COD_WITH_FULL_DATA        14336
&GLOBAL-DEFINE MQRO_PAN                       1
&GLOBAL-DEFINE MQRO_NAN                       2
&GLOBAL-DEFINE MQRO_NEW_MSG_ID                0
&GLOBAL-DEFINE MQRO_PASS_MSG_ID               128
&GLOBAL-DEFINE MQRO_COPY_MSG_ID_TO_CORREL_ID  0
&GLOBAL-DEFINE MQRO_PASS_CORREL_ID            064
&GLOBAL-DEFINE MQRO_DEAD_LETTER_Q             0
&GLOBAL-DEFINE MQRO_DISCARD_MSG               134217728
&GLOBAL-DEFINE MQRO_NONE                      0

/* Message Types */
&GLOBAL-DEFINE MQMT_SYSTEM_FIRST 1
&GLOBAL-DEFINE MQMT_REQUEST      1
&GLOBAL-DEFINE MQMT_REPLY        2
&GLOBAL-DEFINE MQMT_DATAGRAM     8
&GLOBAL-DEFINE MQMT_REPORT       4
&GLOBAL-DEFINE MQMT_SYSTEM_LAST  65535
&GLOBAL-DEFINE MQMT_APPL_FIRST   65536
&GLOBAL-DEFINE MQMT_APPL_LAST    999999999

/* Expiry */
&GLOBAL-DEFINE MQEI_UNLIMITED -1

/* Feedback Values */
&GLOBAL-DEFINE MQFB_NONE                   0
&GLOBAL-DEFINE MQFB_SYSTEM_FIRST           1
&GLOBAL-DEFINE MQFB_QUIT                   256
&GLOBAL-DEFINE MQFB_EXPIRATION             258
&GLOBAL-DEFINE MQFB_COA                    259
&GLOBAL-DEFINE MQFB_COD                    260
&GLOBAL-DEFINE MQFB_PAN                    275
&GLOBAL-DEFINE MQFB_NAN                    276
&GLOBAL-DEFINE MQFB_CHANNEL_COMPLETED      262
&GLOBAL-DEFINE MQFB_CHANNEL_FAIL_RETRY     263
&GLOBAL-DEFINE MQFB_CHANNEL_FAIL           264
&GLOBAL-DEFINE MQFB_APPL_CANNOT_BE_STARTED 265
&GLOBAL-DEFINE MQFB_TM_ERROR               266
&GLOBAL-DEFINE MQFB_APPL_TYPE_ERROR        267
&GLOBAL-DEFINE MQFB_STOPPED_BY_MSG_EXIT    268
&GLOBAL-DEFINE MQFB_XMIT_Q_MSG_ERROR       271
&GLOBAL-DEFINE MQFB_DATA_LENGTH_ZERO       291
&GLOBAL-DEFINE MQFB_DATA_LENGTH_NEGATIVE   292
&GLOBAL-DEFINE MQFB_DATA_LENGTH_TOO_BIG    293
&GLOBAL-DEFINE MQFB_BUFFER_OVERFLOW        294
&GLOBAL-DEFINE MQFB_LENGTH_OFF_BY_ONE      295
&GLOBAL-DEFINE MQFB_IIH_ERROR              296
&GLOBAL-DEFINE MQFB_NOT_AUTHORIZED_FOR_IMS 298
&GLOBAL-DEFINE MQFB_IMS_ERROR              300
&GLOBAL-DEFINE MQFB_IMS_FIRST              301
&GLOBAL-DEFINE MQFB_IMS_LAST               399
&GLOBAL-DEFINE MQFB_SYSTEM_LAST            65535
&GLOBAL-DEFINE MQFB_APPL_FIRST             65536
&GLOBAL-DEFINE MQFB_APPL_LAST              999999999

/* Encoding */
&GLOBAL-DEFINE MQENC_NATIVE 546

/* Coded Character-Set Identifiers */
&GLOBAL-DEFINE MQCCSI_DEFAULT  0
&GLOBAL-DEFINE MQCCSI_Q_MGR    0
&GLOBAL-DEFINE MQCCSI_EMBEDDED -1

/* Formats */
&GLOBAL-DEFINE MQFMT_NONE               "        "
&GLOBAL-DEFINE MQFMT_ADMIN              "MQADMIN "
&GLOBAL-DEFINE MQFMT_CHANNEL_COMPLETED  "MQCHCOM "
&GLOBAL-DEFINE MQFMT_COMMAND_1          "MQCMD1  "
&GLOBAL-DEFINE MQFMT_COMMAND_2          "MQCMD2  "
&GLOBAL-DEFINE MQFMT_DEAD_LETTER_HEADER "MQDEAD  "
&GLOBAL-DEFINE MQFMT_DIST_HEADER        "MQHDIST "
&GLOBAL-DEFINE MQFMT_EVENT              "MQEVENT "
&GLOBAL-DEFINE MQFMT_IMS                "MQIMS   "
&GLOBAL-DEFINE MQFMT_IMS_VAR_STRING     "MQIMSVS "
&GLOBAL-DEFINE MQFMT_MD_EXTENSION       "MQHMDE  "
&GLOBAL-DEFINE MQFMT_PCF                "MQPCF   "
&GLOBAL-DEFINE MQFMT_REF_MSG_HEADER     "MQHREF  "
&GLOBAL-DEFINE MQFMT_STRING             "MQSTR   "
&GLOBAL-DEFINE MQFMT_TRIGGER            "MQTRIG  "
&GLOBAL-DEFINE MQFMT_XMIT_Q_HEADER      "MQXMIT  "

/* Priority */
&GLOBAL-DEFINE MQPRI_PRIORITY_AS_Q_DEF -1

/* Persistence Values */
&GLOBAL-DEFINE MQPER_PERSISTENT           1
&GLOBAL-DEFINE MQPER_NOT_PERSISTENT       0
&GLOBAL-DEFINE MQPER_PERSISTENCE_AS_Q_DEF 2

/* Message Identifier */
&GLOBAL-DEFINE MQMI_NONE ""

/* Correlation Identifier */
&GLOBAL-DEFINE MQCI_NONE ""

/* Accounting Token */
&GLOBAL-DEFINE MQACT_NONE ""

/* Put Application Types */
&GLOBAL-DEFINE MQAT_UNKNOWN    -1
&GLOBAL-DEFINE MQAT_NO_CONTEXT 0
&GLOBAL-DEFINE MQAT_CICS       1
&GLOBAL-DEFINE MQAT_MVS        2
&GLOBAL-DEFINE MQAT_IMS        3
&GLOBAL-DEFINE MQAT_OS2        4
&GLOBAL-DEFINE MQAT_DOS        5
&GLOBAL-DEFINE MQAT_AIX        6
&GLOBAL-DEFINE MQAT_UNIX       6
&GLOBAL-DEFINE MQAT_QMGR       7
&GLOBAL-DEFINE MQAT_OS400      8
&GLOBAL-DEFINE MQAT_WINDOWS    9
&GLOBAL-DEFINE MQAT_CICS_VSE   10
&GLOBAL-DEFINE MQAT_WINDOWS_NT 11
&GLOBAL-DEFINE MQAT_VMS        12
&GLOBAL-DEFINE MQAT_GUARDIAN   13
&GLOBAL-DEFINE MQAT_VOS        14
&GLOBAL-DEFINE MQAT_IMS_BRIDGE 19
&GLOBAL-DEFINE MQAT_XCF        20
&GLOBAL-DEFINE MQAT_DEFAULT    11
&GLOBAL-DEFINE MQAT_USER_FIRST 65536
&GLOBAL-DEFINE MQAT_USER_LAST  999999999

/* Group Identifier */
&GLOBAL-DEFINE MQGI_NONE ""

/* Message Flags */
&GLOBAL-DEFINE MQMF_SEGMENTATION_INHIBITED 0
&GLOBAL-DEFINE MQMF_SEGMENTATION_ALLOWED   1
&GLOBAL-DEFINE MQMF_MSG_IN_GROUP           8
&GLOBAL-DEFINE MQMF_LAST_MSG_IN_GROUP      16
&GLOBAL-DEFINE MQMF_SEGMENT                2
&GLOBAL-DEFINE MQMF_LAST_SEGMENT           4
&GLOBAL-DEFINE MQMF_NONE                   0

/* Original Length */
&GLOBAL-DEFINE MQOL_UNDEFINED -1


/* Structure Length */
&GLOBAL-DEFINE MQMD_CURRENT_LENGTH      364


/*********************************************************************/
/*  MQBO Structure -- Begin Options                                  */
/*********************************************************************/
&GLOBAL-DEFINE MQBO_StrucId     1
&GLOBAL-DEFINE MQBO_Version     5
&GLOBAL-DEFINE MQBO_Options     9

/*********************************************************************/
/*  Values Related to MQBO Structure                                 */
/*********************************************************************/
   
/* Structure Identifier */
&GLOBAL-DEFINE MQBO_STRUC_ID "BO  "
   
/* Structure Version Number */
&GLOBAL-DEFINE MQBO_VERSION_1       1
&GLOBAL-DEFINE MQBO_CURRENT_VERSION 1
   
/* Begin Options */
&GLOBAL-DEFINE MQBO_NONE 0

/* Structure Length */
&GLOBAL-DEFINE MQBO_CURRENT_LENGTH      12


/* String Lengths */
&GLOBAL-DEFINE MQ_ACCOUNTING_TOKEN_LENGTH   32
&GLOBAL-DEFINE MQ_APPL_IDENTITY_DATA_LENGTH 32
&GLOBAL-DEFINE MQ_APPL_NAME_LENGTH          28
&GLOBAL-DEFINE MQ_APPL_ORIGIN_DATA_LENGTH   4
&GLOBAL-DEFINE MQ_AUTHENTICATOR_LENGTH      8
&GLOBAL-DEFINE MQ_BRIDGE_NAME_LENGTH        24
&GLOBAL-DEFINE MQ_CHANNEL_DATE_LENGTH       12
&GLOBAL-DEFINE MQ_CHANNEL_DESC_LENGTH       64
&GLOBAL-DEFINE MQ_CHANNEL_NAME_LENGTH       20
&GLOBAL-DEFINE MQ_CHANNEL_TIME_LENGTH       8
&GLOBAL-DEFINE MQ_CONN_NAME_LENGTH          264
&GLOBAL-DEFINE MQ_CORREL_ID_LENGTH          24
&GLOBAL-DEFINE MQ_CREATION_DATE_LENGTH      12
&GLOBAL-DEFINE MQ_CREATION_TIME_LENGTH      8
&GLOBAL-DEFINE MQ_EXIT_DATA_LENGTH          32
&GLOBAL-DEFINE MQ_EXIT_NAME_LENGTH          128
&GLOBAL-DEFINE MQ_EXIT_USER_AREA_LENGTH     16
&GLOBAL-DEFINE MQ_FORMAT_LENGTH             8
&GLOBAL-DEFINE MQ_GROUP_ID_LENGTH           24
&GLOBAL-DEFINE MQ_LTERM_OVERRIDE_LENGTH     8
&GLOBAL-DEFINE MQ_LUWID_LENGTH              16
&GLOBAL-DEFINE MQ_MCA_JOB_NAME_LENGTH       28
&GLOBAL-DEFINE MQ_MCA_NAME_LENGTH           20
&GLOBAL-DEFINE MQ_MFS_MAP_NAME_LENGTH       8
&GLOBAL-DEFINE MQ_MODE_NAME_LENGTH          8
&GLOBAL-DEFINE MQ_MSG_HEADER_LENGTH         4000
&GLOBAL-DEFINE MQ_MSG_ID_LENGTH             24
&GLOBAL-DEFINE MQ_NAMELIST_DESC_LENGTH      64
&GLOBAL-DEFINE MQ_NAMELIST_NAME_LENGTH      48
&GLOBAL-DEFINE MQ_OBJECT_INSTANCE_ID_LENGTH 24
&GLOBAL-DEFINE MQ_PASSWORD_LENGTH           12
&GLOBAL-DEFINE MQ_PROCESS_APPL_ID_LENGTH    256
&GLOBAL-DEFINE MQ_PROCESS_DESC_LENGTH       64
&GLOBAL-DEFINE MQ_PROCESS_ENV_DATA_LENGTH   128
&GLOBAL-DEFINE MQ_PROCESS_NAME_LENGTH       48
&GLOBAL-DEFINE MQ_PROCESS_USER_DATA_LENGTH  128
&GLOBAL-DEFINE MQ_PUT_APPL_NAME_LENGTH      28
&GLOBAL-DEFINE MQ_PUT_DATE_LENGTH           8
&GLOBAL-DEFINE MQ_PUT_TIME_LENGTH           8
&GLOBAL-DEFINE MQ_Q_DESC_LENGTH             64
&GLOBAL-DEFINE MQ_Q_NAME_LENGTH             48
&GLOBAL-DEFINE MQ_Q_MGR_DESC_LENGTH         64
&GLOBAL-DEFINE MQ_Q_MGR_NAME_LENGTH         48
&GLOBAL-DEFINE MQ_SHORT_CONN_NAME_LENGTH    20
&GLOBAL-DEFINE MQ_STORAGE_CLASS_LENGTH      8
&GLOBAL-DEFINE MQ_TOTAL_EXIT_DATA_LENGTH    999
&GLOBAL-DEFINE MQ_TOTAL_EXIT_NAME_LENGTH    999
&GLOBAL-DEFINE MQ_TP_NAME_LENGTH            64
&GLOBAL-DEFINE MQ_TRAN_INSTANCE_ID_LENGTH   16
&GLOBAL-DEFINE MQ_TRIGGER_DATA_LENGTH       64
&GLOBAL-DEFINE MQ_USER_ID_LENGTH            12

&ENDIF
