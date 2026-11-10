&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ABAPI003 2.00.00.026 } /*** "010026" 16/05/2025 17:37:32 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi003 MAB}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: ABAPI003.p
**
**       DATA....: Agosto de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Atualiza‡Æo Quilometragem
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */

/** Temp-Tables **/
{abp/abapi003.i}  /** Defini‡Æo da ttDocumento **/
{abp/abapi001.i1} /** Defini‡Æo da RowErrors **/
{abp/abapi005.i}  /** Defini‡Æo da tt-param **/
define temp-table RowErrorsEMS no-undo like RowErrors.

define temp-table ttEquipamento no-undo like mab-eqpto
    field r-rowid as rowid
    FIELD lAtualizaPlano AS LOGICAL INITIAL NO
    FIELD dDatMovto      AS DATE.

define temp-table ttImplemento no-undo 
    field ep-codigo  LIKE mab-eqpto.ep-codigo
    FIELD cod-implto LIKE mab-eqpto.cod-eqpto.

/** Parƒmetros **/
define input  parameter pOrigem as integer no-undo. /** 1 = MAB / 2 = MPN / 3 = MMV **/
define input  parameter table for ttDocumento.
define output parameter table for RowErrors.

/** Vari veis locais **/
DEFINE VARIABLE deComeco           LIKE mab-abastec-lubrific.val-dat-hora-invrtda  NO-UNDO.
DEFINE VARIABLE deComecoImplto     LIKE mab-abastec-lubrific.val-dat-hora-invrtda  NO-UNDO.
DEFINE VARIABLE deKMAnt            LIKE mab-movto-km-eqpto.val-km-real             NO-UNDO.
DEFINE VARIABLE deKMSecAnt         LIKE mab-movto-km-eqpto.val-livre-2             NO-UNDO. /* Referente ao campo val-km-sec (Valida‡Æo Contador Secund rio) */
DEFINE VARIABLE deKMAntSemAbast    LIKE mab-movto-km-eqpto.val-km-real             NO-UNDO.
DEFINE VARIABLE deKMSecAntSemAbast LIKE mab-movto-km-eqpto.val-livre-2             NO-UNDO. /* Referente ao campo val-km-sec (Valida‡Æo Contador Secund rio) */
DEFINE VARIABLE deInvertida        LIKE mab-abastec-lubrific.val-dat-hora-invrtda  NO-UNDO.
DEFINE VARIABLE cHora              AS   CHARACTER  format "99:99:99"               NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.92
         WIDTH              = 31.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{abp/ab9000.i}    /** ConversÆo de horas **/
{abp/abapi001.i2} /** Cria‡Æo de Erros **/

run piInicializacao in this-procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piAbastecimento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAbastecimento Procedure 
PROCEDURE piAbastecimento :
/*------------------------------------------------------------------------------
  Purpose:     piAbastecimento
  Parameters:  <none>
  Notes:       Atualiza‡Æo abastecimento
------------------------------------------------------------------------------*/
define buffer bfKM for mab-movto-km-eqpto.

/** Busca Primeiro documento do equipamento **/
for first ttDocumento fields(val-dat-hora-invrtda)
    where ttDocumento.ep-codigo = ttEquipamento.ep-codigo
    and   ttDocumento.cod-eqpto = ttEquipamento.cod-eqpto no-lock
    by ttDocumento.val-dat-hora-invrtda:
    assign deComeco = ttDocumento.val-dat-hora-invrtda.
    /** Atualiza menor data para come‡ar a atualizar os implementos **/
    IF deComecoImplto = 0 or deComecoImplto > deComeco THEN 
        assign deComecoImplto = deComeco.
end.

/** Equipamentos Motorizados, busca Quilometragem de Abastecimento Prim rio **/
/** Somente para abastecimento busca abastecimento prim rio, porque Movimento de KM 
    diferente de MAB, calcula a quilometragem em fun‡Æo do £ltimo contador **/
IF ttEquipamento.idi-tip-eqpto = 1 and  /** Motorizado **/
   pOrigem = 1 THEN DO:                 /** MAB **/
    /* Busca £ltima vida do equipamento, independentemente se ficha ‚ de abastecimento ou nÆo */
    for last  mab-movto-km-eqpto fields(cod-eqpto val-km-real num-docto dat-movto val-livre-2) USE-INDEX mbmvtkmq-id
        where mab-movto-km-eqpto.ep-codigo            = ttEquipamento.ep-codigo
        and   mab-movto-km-eqpto.cod-eqpto            = ttEquipamento.cod-eqpto
        and   mab-movto-km-eqpto.val-dat-hora-invrtda < deComeco no-lock:
        /** Vida est  zerada, deve-se criar erro e buscar pr¢ximo equipamento **/
        if mab-movto-km-eqpto.val-km-real = 0 then do:
            run piCriaErro in this-procedure (28499, 'EMS':U, mab-movto-km-eqpto.cod-eqpto).
            return "NOK":U.
        end.
        assign deKMAntSemAbast = mab-movto-km-eqpto.val-km-real.
        /* Valida‡Æo Contador Secund rio */
        /* Caso o equipamento controla contador secund rio, deve validar se a vida est  zerada */
        /* val-livre-2 - Referente ao campo val-km-sec */
        IF  ttEquipamento.log-cont-sec THEN DO:
            ASSIGN deKMSecAntSemAbast = mab-movto-km-eqpto.val-livre-2.
        END.
    end.
    /** Willwock - Para resolver KM zerado **/
    if not avail mab-movto-km-eqpto then
       assign deKMAntSemAbast    = ttEquipamento.val-km-inicial
              deKMSecAntSemAbast = ttEquipamento.val-km-sec. /* (Valida‡Æo Contador Secund rio) */
    /** Busca Vida Anterior no Hist¢rico **/
    if can-find(first mab-movto-km-eqpto
                where mab-movto-km-eqpto.ep-codigo            = ttEquipamento.ep-codigo
                and   mab-movto-km-eqpto.cod-eqpto            = ttEquipamento.cod-eqpto
                and   mab-movto-km-eqpto.log-abastec-prim
                and   mab-movto-km-eqpto.val-dat-hora-invrtda < deComeco no-lock) THEN DO:
        /** Vida anterior **/
        for last  mab-movto-km-eqpto fields(cod-eqpto val-km-real dat-movto val-livre-2) USE-INDEX mbmvtkmq-id
            where mab-movto-km-eqpto.ep-codigo            = ttEquipamento.ep-codigo
            and   mab-movto-km-eqpto.cod-eqpto            = ttEquipamento.cod-eqpto
            and   mab-movto-km-eqpto.log-abastec-prim
            and   mab-movto-km-eqpto.val-dat-hora-invrtda < deComeco no-lock:
            /** Vida est  zerada, deve-se criar erro e buscar pr¢ximo equipamento **/
            if mab-movto-km-eqpto.val-km-real = 0 then do:
                run piCriaErro in this-procedure (28499, 'EMS':U, mab-movto-km-eqpto.cod-eqpto).
                return "NOK":U.
            end.
            /** Vida Anterior **/
            assign deKMAnt = mab-movto-km-eqpto.val-km-real.
            /* Valida‡Æo Contador Secund rio */
            /* Caso o equipamento controla contador secund rio, deve validar se a vida est  zerada */
            /* val-livre-2 - Referente ao campo val-km-real-sec */
            IF  ttEquipamento.log-cont-sec THEN DO:
                assign deKMSecAnt = mab-movto-km-eqpto.val-livre-2.
            END.
        end.        
    end.        
    ELSE DO:
        /** Vida Inicial **/
        assign deKMAnt = ttEquipamento.val-km-inicial.
        IF  ttEquipamento.log-cont-sec THEN
            assign deKMSecAnt = ttEquipamento.val-km-sec. /* Valida‡Æo Contador Secund rio */
    END.
END.
/** Equipamentos NÆo Motorizados, busca £ltima quilometragem **/
ELSE DO:
    /** Busca Vida Anterior no Hist¢rico **/
    if can-find(first mab-movto-km-eqpto
                where mab-movto-km-eqpto.ep-codigo            = ttEquipamento.ep-codigo
                and   mab-movto-km-eqpto.cod-eqpto            = ttEquipamento.cod-eqpto
                and   mab-movto-km-eqpto.val-dat-hora-invrtda < deComeco no-lock) THEN DO:
        /** Vida anterior **/
        for last  mab-movto-km-eqpto fields(cod-eqpto val-km-real dat-movto val-livre-2) USE-INDEX mbmvtkmq-id
            where mab-movto-km-eqpto.ep-codigo            = ttEquipamento.ep-codigo
            and   mab-movto-km-eqpto.cod-eqpto            = ttEquipamento.cod-eqpto
            and   mab-movto-km-eqpto.val-dat-hora-invrtda < deComeco no-lock:
            /** Vida est  zerada, deve-se criar erro e buscar pr¢ximo equipamento **/
            /*if mab-movto-km-eqpto.val-km-real = 0 then do:
                run piCriaErro in this-procedure (28499, 'EMS':U, mab-movto-km-eqpto.cod-eqpto).
                return "NOK":U.
            end.*/
            /** Vida Anterior **/
            assign deKMAnt         = mab-movto-km-eqpto.val-km-real.
                   deKMAntSemAbast = mab-movto-km-eqpto.val-km-real.
            /* Valida‡Æo Contador Secund rio */
            /* Caso o equipamento controla contador secund rio, deve validar se a vida est  zerada */
            /* val-livre-2 - Referente ao campo val-km-sec */
            IF  ttEquipamento.log-cont-sec THEN DO:
                /** Vida Anterior **/
                ASSIGN deKMSecAnt         = mab-movto-km-eqpto.val-livre-2.
                       deKMSecAntSemAbast = mab-movto-km-eqpto.val-livre-2.
            END.
       end.
    END.
    ELSE DO:
        /** Vida Inicial **/
        assign deKMAnt         = ttEquipamento.val-km-inicial
               deKMAntSemAbast = ttEquipamento.val-km-inicial.
        /* Valida‡Æo Contador Secund rio */
        IF  ttEquipamento.log-cont-sec THEN DO:
            ASSIGN deKMSecAnt         = ttEquipamento.val-km-sec
                   deKMSecAntSemAbast = ttEquipamento.val-km-sec.
        END.
   END.
END.
/** Come‡a a atualizar vida do equipamento a partir da data do documento **/
for each  mab-movto-km-eqpto USE-INDEX mbmvtkmq-id
    where mab-movto-km-eqpto.ep-codigo             = ttEquipamento.ep-codigo
    and   mab-movto-km-eqpto.cod-eqpto             = ttEquipamento.cod-eqpto
    and   mab-movto-km-eqpto.val-dat-hora-invrtda >= deComeco exclusive-lock:
    /** Movimento de abastecimento **/
    IF  mab-movto-km-eqpto.idi-origem = 1 
    AND mab-movto-km-eqpto.log-abastec-prim then do:
        /** Atualiza conforme ficha alterada **/
        if can-find(first ttDocumento
                    where ttDocumento.ep-codigo = mab-movto-km-eqpto.ep-codigo
                    and   ttDocumento.cod-eqpto = mab-movto-km-eqpto.cod-eqpto
                    AND   ttDocumento.i-origem  = mab-movto-km-eqpto.idi-origem  /** Willwock - Diferenciar Doctos iguais de origens diferentes **/
                    and   ttDocumento.num-docto = mab-movto-km-eqpto.num-docto no-lock) then do:
            for first ttDocumento fields(val-km-percur num-docto val-livre-1)
                where ttDocumento.ep-codigo = mab-movto-km-eqpto.ep-codigo
                and   ttDocumento.cod-eqpto = mab-movto-km-eqpto.cod-eqpto
                AND   ttDocumento.i-origem  = mab-movto-km-eqpto.idi-origem  /** Willwock - Diferenciar Doctos iguais de origens diferentes **/
                and   ttDocumento.num-docto = mab-movto-km-eqpto.num-docto no-lock:
                /** Atualiza KM Real com o anterior mais o pecorrido pelo documento **/
                ASSIGN mab-movto-km-eqpto.val-km-real  = deKMAnt + ttDocumento.val-km-percur.
                /* Valida‡Æo Contador Secund rio */
                /* val-livre-2 - Referente ao campo val-km-sec */
                IF  ttEquipamento.log-cont-sec THEN
                    ASSIGN mab-movto-km-eqpto.val-livre-2  = deKMSecAnt + ttDocumento.val-livre-1.

                /** Somente atualiza KM anteior quando ficha atual for de abastecimento **/
                if ttequipamento.idi-tip-eqpto = 1 THEN DO:
                    FOR FIRST mab-item-abastec 
                        WHERE mab-item-abastec.num-docto = ttdocumento.num-docto
                        and   mab-item-abastec.log-abastec-prim NO-LOCK:
                    END.
                    IF AVAIL mab-item-abastec THEN DO:
                       ASSIGN deKMAnt = deKMAnt + ttDocumento.val-km-percur.
                       /*-----------------------------------------------------------------------------------------------------*/
                       /* Quando apontamento for de abastecimento, o sistema verifica se vida anterior ‚ maior que vida atual */
                       /* calculada. Isto porque vida anterior pode ter sido gerada pelo m¢dulo de Pneus ou Manuten‡Æo        */
                       /* que nÆo possuem uma consistˆncia forte com rela‡Æo a diferen‡a de contadores.                       */
                       /*-----------------------------------------------------------------------------------------------------*/
                       IF deKMAntSemAbast > mab-movto-km-eqpto.val-km-real THEN DO:
                           run piCriaErro in this-procedure (input 34791, 
                                                             input 'EMS':U, 
                                                             input mab-movto-km-eqpto.cod-eqpto                      + '~~' +
                                                                   string(mab-movto-km-eqpto.ep-codigo)              + '~~' +
                                                                   string(mab-movto-km-eqpto.dat-movto,'99/99/9999') + '~~' +
                                                                   string(mab-movto-km-eqpto.num-docto)).
                           /*ASSIGN mab-movto-km-eqpto.val-km-real = deKMAntSemAbast
                                  deKmAnt                        = deKMAntSemAbast.*/ /*Se apresenta mensagem de erro, o sistema nÆo deve 
                                                                                        deixar passa*/
                       END.
                       /* Valida‡Æo Contador Secund rio */
                       /* val-livre-2 - Referente ao campo val-km-sec */
                       IF  ttEquipamento.log-cont-sec THEN DO:
                           ASSIGN deKMSecAnt = deKMSecAnt + ttDocumento.val-livre-1.
                          /*-----------------------------------------------------------------------------------------------------*/
                          /* Quando apontamento for de abastecimento, o sistema verifica se vida anterior ‚ maior que vida atual */
                          /* calculada. Isto porque vida anterior pode ter sido gerada pelo m¢dulo de Pneus ou Manuten‡Æo        */
                          /* que nÆo possuem uma consistˆncia forte com rela‡Æo a diferen‡a de contadores.                       */
                          /*-----------------------------------------------------------------------------------------------------*/
                          IF deKMSecAntSemAbast > mab-movto-km-eqpto.val-livre-2 THEN DO:
                              ASSIGN mab-movto-km-eqpto.val-livre-2 = deKMSecAntSemAbast
                                     deKmSecAnt                     = deKMSecAntSemAbast.
                          END.
                       END.
                    END.
                    ELSE DO:
                        /*-----------------------------------------------------------------------------------------------------*/
                        /* Quando apontamento nÆo for de abastecimento, o sistema verifica se vida anterior ‚ maior que vida   */
                        /* atual calculada. Isto porque vida anterior pode ter sido gerada pelo m¢dulo de Pneus ou Manuten‡Æo  */
                        /* que nÆo possuem uma consistˆncia forte com rela‡Æo a diferen‡a de contadores.                       */
                        /*-----------------------------------------------------------------------------------------------------*/
                        IF deKMAntSemAbast > mab-movto-km-eqpto.val-km-real THEN DO:
                            ASSIGN mab-movto-km-eqpto.val-km-real = deKMAntSemAbast.
                        END.
                        /* Valida‡Æo Contador Secund rio */
                        /* val-livre-2 - Referente ao campo val-km-sec */
                        IF  ttEquipamento.log-cont-sec THEN DO:
                            IF deKMSecAntSemAbast > mab-movto-km-eqpto.val-livre-2 THEN DO:
                                ASSIGN mab-movto-km-eqpto.val-livre-2 = deKMSecAntSemAbast.
                            END.
                        END.
                    END.
                END.  /* First ttDocumento */ 
                ELSE DO:
                    FOR FIRST mab-abastec-lubrific 
                        WHERE mab-abastec-lubrific.num-docto = ttdocumento.num-docto NO-LOCK:
                    END.
                    IF  AVAIL mab-abastec-lubrific THEN DO:
                       ASSIGN deKMAnt = deKMAnt + ttDocumento.val-km-percur.
                       /*-----------------------------------------------------------------------------------------------------*/
                       /* Quando apontamento for de abastecimento, o sistema verifica se vida anterior ‚ maior que vida atual */
                       /* calculada. Isto porque vida anterior pode ter sido gerada pelo m¢dulo de Pneus ou Manuten‡Æo        */
                       /* que nÆo possuem uma consistˆncia forte com rela‡Æo a diferen‡a de contadores.                       */
                       /*-----------------------------------------------------------------------------------------------------*/
                       IF deKMAntSemAbast > mab-movto-km-eqpto.val-km-real THEN DO:
                           run piCriaErro in this-procedure (input 34791, 
                                                             input 'EMS':U, 
                                                             input mab-movto-km-eqpto.cod-eqpto                      + '~~' +
                                                                   string(mab-movto-km-eqpto.ep-codigo)              + '~~' +
                                                                   string(mab-movto-km-eqpto.dat-movto,'99/99/9999') + '~~' +
                                                                   string(mab-movto-km-eqpto.num-docto)).
                           /*ASSIGN mab-movto-km-eqpto.val-km-real = deKMAntSemAbast
                                  deKmAnt                        = deKMAntSemAbast.*/ /*Se apresenta mensagem de erro, o sistema nÆo deve 
                                                                                        deixar passa*/
                       END.
                       /* Valida‡Æo Contador Secund rio */
                       /* val-livre-2 - Referente ao campo val-km-sec */
                       IF  ttEquipamento.log-cont-sec THEN DO:
                           ASSIGN deKMSecAnt = deKMSecAnt + ttDocumento.val-livre-1.
                          /*-----------------------------------------------------------------------------------------------------*/
                          /* Quando apontamento for de abastecimento, o sistema verifica se vida anterior ‚ maior que vida atual */
                          /* calculada. Isto porque vida anterior pode ter sido gerada pelo m¢dulo de Pneus ou Manuten‡Æo        */
                          /* que nÆo possuem uma consistˆncia forte com rela‡Æo a diferen‡a de contadores.                       */
                          /*-----------------------------------------------------------------------------------------------------*/
                          IF deKMSecAntSemAbast > mab-movto-km-eqpto.val-livre-2 THEN DO:
                              ASSIGN mab-movto-km-eqpto.val-livre-2 = deKMSecAntSemAbast
                                     deKmSecAnt                     = deKMSecAntSemAbast.
                          END.
                       END.
                    END.
                    ELSE DO:
                        /*-----------------------------------------------------------------------------------------------------*/
                        /* Quando apontamento nÆo for de abastecimento, o sistema verifica se vida anterior ‚ maior que vida   */
                        /* atual calculada. Isto porque vida anterior pode ter sido gerada pelo m¢dulo de Pneus ou Manuten‡Æo  */
                        /* que nÆo possuem uma consistˆncia forte com rela‡Æo a diferen‡a de contadores.                       */
                        /*-----------------------------------------------------------------------------------------------------*/
                        IF deKMAntSemAbast > mab-movto-km-eqpto.val-km-real THEN DO:
                            ASSIGN mab-movto-km-eqpto.val-km-real = deKMAntSemAbast.
                        END.
                        /* Valida‡Æo Contador Secund rio */
                        /* val-livre-2 - Referente ao campo val-km-sec */
                        IF  ttEquipamento.log-cont-sec THEN DO:
                            IF deKMSecAntSemAbast > mab-movto-km-eqpto.val-livre-2 THEN DO:
                                ASSIGN mab-movto-km-eqpto.val-livre-2 = deKMSecAntSemAbast.
                            END.
                        END.
                    END.
                END.  /* First ttDocumento */ 

                ASSIGN deKMAntSemAbast = mab-movto-km-eqpto.val-km-real.
                /* Valida‡Æo Contador Secund rio */
                /* val-livre-2 - Referente ao campo val-km-sec */
                IF  ttEquipamento.log-cont-sec THEN
                    ASSIGN deKMSecAntSemAbast = mab-movto-km-eqpto.val-livre-2.
            end.
        end.
        /** Atualiza conforme dados j  existentes **/
        else do:
            /** Verifica **/
            FOR FIRST mab-abastec-lubrific
                where mab-abastec-lubrific.ep-codigo = mab-movto-km-eqpto.ep-codigo
                and   mab-abastec-lubrific.cod-eqpto = mab-movto-km-eqpto.cod-eqpto
                and   mab-abastec-lubrific.num-docto = mab-movto-km-eqpto.num-docto NO-LOCK:
            END.
            IF  AVAIL mab-abastec-lubrific THEN DO:
                for first mab-abastec-lubrific fields(val-km-percur num-docto idi-consist val-livre-1)
                    where mab-abastec-lubrific.ep-codigo = mab-movto-km-eqpto.ep-codigo
                    and   mab-abastec-lubrific.cod-eqpto = mab-movto-km-eqpto.cod-eqpto
                    and   mab-abastec-lubrific.num-docto = mab-movto-km-eqpto.num-docto no-lock:
    
                    assign mab-movto-km-eqpto.val-km-real = deKMAnt + mab-abastec-lubrific.val-km-percur.
                    /* Valida‡Æo Contador Secund rio */
                    /* val-livre-2 - Referente ao campo val-km-sec */
                    IF  ttEquipamento.log-cont-sec THEN
                        ASSIGN mab-movto-km-eqpto.val-livre-2 = deKMSecAnt + mab-abastec-lubrific.val-livre-1.
                           
                    /** Somente atualiza KM anteior quando ficha atual for de abastecimento **/
                    if ttequipamento.idi-tip-eqpto = 1 THEN DO:
                        FOR FIRST mab-item-abastec 
                            WHERE mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto
                            AND   mab-item-abastec.log-abastec-prim NO-LOCK:
                        END.
                        IF AVAIL mab-item-abastec THEN DO:
                           ASSIGN deKMAnt = deKMAnt + mab-abastec-lubrific.val-km-percur.
                           /*-----------------------------------------------------------------------------------------------------*/
                           /* Quando apontamento for de abastecimento, o sistema verifica se vida anterior ² maior que vida atual */
                           /* calculada. Isto porque vida anterior pode ter sido gerada pelo m½dulo de Pneus ou Manuten»’o        */
                           /* que n’o possuem uma consist¼ncia forte com rela»’o a diferen»a de contadores.                       */
                           /*-----------------------------------------------------------------------------------------------------*/
                           IF  deKMAntSemAbast > mab-movto-km-eqpto.val-km-real THEN DO:
                               run piCriaErro in this-procedure (input 34791, 
                                                                 input 'EMS':U, 
                                                                 input mab-movto-km-eqpto.cod-eqpto                      + '~~' +
                                                                       string(mab-movto-km-eqpto.ep-codigo)              + '~~' +
                                                                       string(mab-movto-km-eqpto.dat-movto,'99/99/9999') + '~~' +
                                                                       string(mab-movto-km-eqpto.num-docto)).

                               /*ASSIGN mab-movto-km-eqpto.val-km-real = deKMAntSemAbast
                                      deKmAnt                        = deKMAntSemAbast.*/ /*Se apresenta mensagem de erro, o sistema nÆo 
                                                                                            deve deixa passar */
                           END.
                           /* Valida‡Æo Contador Secund rio */
                           IF  ttEquipamento.log-cont-sec THEN DO:
                               ASSIGN deKMSecAnt = deKMSecAnt + mab-abastec-lubrific.val-livre-1.
                              /*-----------------------------------------------------------------------------------------------------*/
                              /* Quando apontamento for de abastecimento, o sistema verifica se vida anterior ² maior que vida atual */
                              /* calculada. Isto porque vida anterior pode ter sido gerada pelo m½dulo de Pneus ou Manuten»’o        */
                              /* que n’o possuem uma consist¼ncia forte com rela»’o a diferen»a de contadores.                       */
                              /*-----------------------------------------------------------------------------------------------------*/
                              IF  deKMSecAntSemAbast > mab-movto-km-eqpto.val-livre-2 THEN DO:
                                  ASSIGN mab-movto-km-eqpto.val-livre-2 = deKMSecAntSemAbast
                                         deKmSecAnt                     = deKMSecAntSemAbast.
                              END.
                           END.
                        END.
                        ELSE DO:
                            /*-----------------------------------------------------------------------------------------------------*/
                            /* Quando apontamento n’o for de abastecimento, o sistema verifica se vida anterior ² maior que vida   */
                            /* atual calculada. Isto porque vida anterior pode ter sido gerada pelo m½dulo de Pneus ou Manuten»’o  */
                            /* que n’o possuem uma consist¼ncia forte com rela»’o a diferen»a de contadores.                       */
                            /*-----------------------------------------------------------------------------------------------------*/
                            IF  deKMAntSemAbast > mab-movto-km-eqpto.val-km-real THEN DO:
                                ASSIGN mab-movto-km-eqpto.val-km-real = deKMAntSemAbast.
                            END.
                            IF  ttEquipamento.log-cont-sec THEN DO:         /* Valida‡Æo Contador Secund rio */
                                IF  deKMSecAntSemAbast > mab-movto-km-eqpto.val-livre-2 THEN DO:
                                    ASSIGN mab-movto-km-eqpto.val-livre-2 = deKMSecAntSemAbast.
                                END.
                            END.
                        END.
                    END.
                END.
                ASSIGN deKMAntSemAbast = mab-movto-km-eqpto.val-km-real.
                IF  ttEquipamento.log-cont-sec THEN         /* Valida‡Æo Contador Secund rio */
                    ASSIGN deKMSecAntSemAbast = mab-movto-km-eqpto.val-livre-2.
            END.
            ELSE DO:
                /** Calcula KM quando n’o ² origem MAB ou n’o encontrou ficha de abastecimento **/
                RUN piKMHistorico IN THIS-PROCEDURE.
            END.
        end.
    end.
    /** Outros tipos de movimento de KM, geram o KM real conforme diferen‡a entre apontamentos **/
    else do:
        /** Calcula KM quando n’o ² origem MAB ou n’o encontrou ficha de abastecimento **/
        RUN piKMHistorico IN THIS-PROCEDURE.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicializacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicializacao Procedure 
PROCEDURE piInicializacao :
/*------------------------------------------------------------------------------
  Purpose:     piInicializacao
  Parameters:  <none>
  Notes:       Inicializa‡Æo da API
------------------------------------------------------------------------------*/
DEFINE VARIABLE iErro        AS INTEGER    NO-UNDO.
DEFINE BUFFER   bfImplto     FOR mab-eqpto.
DEFINE VAR      dData-Implto AS DATE.

DISABLE TRIGGERS FOR DUMP OF mab-movto-km-eqpto.
DISABLE TRIGGERS FOR DUMP OF mab-item-abastec.
DISABLE TRIGGERS FOR DUMP OF mab-movto-km-eqpto.
DISABLE TRIGGERS FOR DUMP OF mab-item-abastec.

/** Cria‡Æo ttEquipamento **/
for each ttDocumento:
    FOR first ttEquipamento 
        where ttEquipamento.ep-codigo = ttDocumento.ep-codigo
        and   ttEquipamento.cod-eqpto = ttdocumento.cod-eqpto NO-LOCK:
    END.
    IF NOT AVAIL ttEquipamento THEN DO:
        for first mab-eqpto
            where mab-eqpto.ep-codigo = ttDocumento.ep-codigo
            and   mab-eqpto.cod-eqpto = ttDocumento.cod-eqpto no-lock:
            create ttEquipamento.
            buffer-copy mab-eqpto to ttEquipamento
                assign ttEquipamento.r-rowid = rowid(mab-eqpto)
                       ttEquipamento.dDatMovto = ttDocumento.dat-movto.
        end.
    end.
end.

/** Percorre os equipamentos que devem ser atualizados **/
for each ttEquipamento WHERE ttEquipamento.lAtualizaPlano = FALSE no-lock:

    /** Atualiza‡Æo da vida do equipamento atrav‚s dos abastecimento **/
    run piAbastecimento in this-procedure.
    if return-value = "NOK":U then next.

    /** Atualiza‡Æo dos planos de manuten‡Æo dos compartimentos **/
    run piLubrificacao in this-procedure.
    if return-value = "NOK":U then next.
    
    /** Atualiza‡Æo dos planos de manuten‡Æo preventiva dos equipamentos **/
    run piPlanoPreventiva in this-procedure.
    if return-value = "NOK":U then next.

end.
    
/*----------------------------------------------------------------------------------------------*/
/** Atualiza‡Æo a quilometragem dos implementos conforme Quilometragem dos Equipamentos        **/
/** Somente se no cadastro de parƒmetros estiver marcado para gerar KM de implemento conforme  **/
/** percurso rodado pelo equipamento relacionado.                                              **/
/*----------------------------------------------------------------------------------------------*/
/* Deve-se partir do Cadastro de Implementos (representado por ttImplemento, para depois ler    */
/* o relacionamento com a tabela mgf-eqpto-implto, pois se ler direto pelo cadastro de eqpto    */
/* Pode gerar vida negativa, quando implemento relacionado com mais de 1 equipamento.           */
/*----------------------------------------------------------------------------------------------*/

IF CAN-FIND(FIRST mab-param WHERE mab-param.cdn-param = 36 AND mab-param.des-valor = "1") AND deComecoImplto > 0 THEN DO:
   
   ASSIGN dData-Implto = DATE(INT(SUBSTRING(STRING(deComecoImplto, "999999999999"), 5, 2)), 
                              INT(SUBSTRING(STRING(deComecoImplto, "999999999999"), 7, 2)), 
                              INT(SUBSTRING(STRING(deComecoImplto, "999999999999"), 1, 4))). 

   FOR EACH ttEquipamento WHERE ttEquipamento.idi-tip-eqpto = 1 NO-LOCK: /* Equipamento MOtorizado */
       FOR EACH  mgf-eqpto-implto FIELDS (ep-codigo-implto cod-implto) 
           WHERE mgf-eqpto-implto.ep-codigo-eqpto = ttEquipamento.ep-codigo
             AND mgf-eqpto-implto.cod-eqpto       = ttEquipamento.cod-eqpto NO-LOCK:

           IF NOT CAN-FIND (FIRST ttImplemento WHERE ttImplemento.ep-codigo  = mgf-eqpto-implto.ep-codigo-implto
                                                 AND ttImplemento.cod-implto = mgf-eqpto-implto.cod-implto) THEN DO:
               CREATE ttImplemento.
               ASSIGN ttImplemento.ep-codigo  = mgf-eqpto-implto.ep-codigo-implto
                      ttImplemento.cod-implto = mgf-eqpto-implto.cod-implto.
           END.

       END.
   END.

   FOR EACH ttImplemento NO-LOCK:
       /* Data Inicial foi retirada do where pq se o implemente tiver uma data que seja maior que a data inicial do primeiro documento, o mesmo nÆo esta sendo considerado
       tamb‚m foi incluido a valida‡Æo da data inicial na procedure piPercursoImplementos, garantindo assim, que os movimentos para o implemento somente sejam gerados
       se estiverem dentro da faixa de datas definidas no programa ab0123.
       */
       FOR EACH mgf-eqpto-implto WHERE mgf-eqpto-implto.ep-codigo-implto = ttImplemento.ep-codigo
                                   AND mgf-eqpto-implto.cod-implto       = ttImplemento.cod-implto
                                   /*AND mgf-eqpto-implto.dat-inicial      <= dData-Implto*/
                                   AND mgf-eqpto-implto.dat-final        >= dData-Implto NO-LOCK BY mgf-eqpto-implto.dat-inicial:

           /*--------------------------------------------------------------------------------------------------------*/
           /* Se calculada o percurso do implemento para um equipamento que esteja na consistˆncia, deve-se calcular */
           /* o percurso deste implemento at‚ a daa atual, mesmo que os demais equipamentos que ele tenha passsao    */
           /* nÆo estejam na consistencia. Desta forma, garante-se que nÆo seja gerada Vida Negativa. Carlos Xavier  */
           /*--------------------------------------------------------------------------------------------------------*/
           run piPercursoImplementos  in THIS-PROCEDURE (INPUT dData-Implto,
                                                         INPUT mgf-eqpto-implto.dat-final).
    
       END.

   END.
END.


/*------------------------------------------------------------*/
/*  Percorre os implementos que devem ser atualizados         */
/* Somente passar  por este processo quando KM de implementos */
/* for gerado conforme percurso do equipamento relacionado    */
/*------------------------------------------------------------*/
for each ttEquipamento WHERE ttEquipamento.lAtualizaPlano = TRUE no-lock:

    /** Atualiza‡Æo dos planos de manuten‡Æo dos compartimentos **/
    run piLubrificacao in this-procedure.
    if return-value = "NOK":U then next.
    
    /** Atualiza‡Æo dos planos de manuten‡Æo preventiva dos equipamentos **/
    run piPlanoPreventiva in this-procedure.
    if return-value = "NOK":U then next.

END.
/** Somente para Abastecimento Roda a Consistencia **/
if pOrigem = 1 then
    /** Roda a Integra Estoque **/
    for first mab-param-integr
        where mab-param-integr.cdn-param = 8 no-lock:
        /** 1= NÆo Integra 
            2= Integra On-line
            3= Integra Batch **/
        if mab-param-integr.des-valor = "2" then do:
            run abp/abapi005.p (INPUT ?, /** NÆo tem acompanhamento **/
                                input  table tt-param,
                                input  table ttDocumento,
                                output table RowErrorsEMS).
            /** Busca £ltimo erro criado na BO **/
            for last RowErrors no-lock:
                assign iErro = RowErrors.ErrorSequence.
            end.
            /** Percorre os erros da API **/
            for each RowErrorsEMS no-lock:
                /** Cria eros na BO **/
                create RowErrors.
                buffer-copy RowErrorsEMS except ErrorSequence to RowErrors
                    /** Coloca sequˆncia **/
                    assign RowErrors.ErrorSequence = iErro + 1.
                assign iErro = RowErrors.ErrorSequence.
            end.
        end.
    end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piKMHistorico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piKMHistorico Procedure 
PROCEDURE piKMHistorico :
/*------------------------------------------------------------------------------
  Purpose:     piKMHistorico
  Parameters:  <none>
  Notes:       Calcula KM quando n’o ² origem MAB ou n’o encontrou ficha de abastecimento
------------------------------------------------------------------------------*/
DEFINE BUFFER bfKM FOR mab-movto-km-eqpto.

/** Busca Vida Anterior no Hist½rico **/
if can-find(first bfKM
            where bfKM.ep-codigo            = ttEquipamento.ep-codigo
            and   bfKM.cod-eqpto            = ttEquipamento.cod-eqpto
            and   bfKM.val-dat-hora-invrtda < mab-movto-km-eqpto.val-dat-hora-invrtda no-lock) THEN DO:
    
    IF CAN-FIND (FIRST bfKM 
                 where bfKM.ep-codigo            = ttEquipamento.ep-codigo
                   and bfKM.cod-eqpto            = ttEquipamento.cod-eqpto
                   AND bfkm.val-hodom-horim     <> 0
                   and bfKM.val-dat-hora-invrtda < mab-movto-km-eqpto.val-dat-hora-invrtda no-lock)THEN DO:

        /** Vida Anterior **/
        for last  bfKM fields(val-hodom-horim  bfkm.num-docto val-km-real val-livre-1 val-livre-2 cod-livre-1 val-dat-hora-invrtda)
            where bfKM.ep-codigo            = ttEquipamento.ep-codigo
            and   bfKM.cod-eqpto            = ttEquipamento.cod-eqpto
            AND   bfkm.val-hodom-horim     <> 0
            and   bfKM.val-dat-hora-invrtda < mab-movto-km-eqpto.val-dat-hora-invrtda no-lock:
            /** Contador maior que contador anterior **/
            IF mab-movto-km-eqpto.val-hodom-horim >= bfKM.val-hodom-horim and 
               bfKM.val-hodom-horim > 0 THEN DO: /* maior que zero para n’o causar erro de cÿlculo do percurso */
                assign mab-movto-km-eqpto.val-km-real = deKMAntSemAbast + (mab-movto-km-eqpto.val-hodom-horim - bfKM.val-hodom-horim)
                       deKMAntSemAbast                = mab-movto-km-eqpto.val-km-real.
            END.
            /** Caso houver problemas de contador, deixa mesmo contador no movimento **/
            else do:
                IF ttEquipamento.idi-tip-eqpto = 1 /*Equipamento Motorizado*/
                THEN DO:
                    assign mab-movto-km-eqpto.val-km-real = bfKM.val-km-real + mab-movto-km-eqpto.val-hodom-horim
                           deKMAntSemAbast                = mab-movto-km-eqpto.val-km-real.
                END.
                ELSE DO:
                    assign mab-movto-km-eqpto.val-km-real = deKMAntSemAbast + (mab-movto-km-eqpto.val-km-real - bfKM.val-km-real) /*bfKM.val-km-real*/
                           mab-movto-km-eqpto.val-km-real = IF mab-movto-km-eqpto.val-hodom-horim > 0 THEN mab-movto-km-eqpto.val-km-real ELSE bfKM.val-km-real
                           deKMAntSemAbast                = mab-movto-km-eqpto.val-km-real.

                END.
            end.
            /* Valida‡Æo Contador Secund rio */
            IF  ttEquipamento.log-cont-sec THEN DO:
                /** Contador Secundario maior que contador anterior **/
                /* val-livre-1 referente ao campo val-hodom-horim-sec (Valida‡Æo Contador Secund rio) */
                /* val-livre-2 referente ao campo val-km-real-sec */
                IF mab-movto-km-eqpto.val-livre-1 >= bfKM.val-livre-1 and 
                   bfKM.val-livre-1 > 0 THEN DO: /* maior que zero para n’o causar erro de cÿlculo do percurso */
                    assign mab-movto-km-eqpto.val-livre-2 = deKMSecAntSemAbast + (mab-movto-km-eqpto.val-livre-1 - bfKM.val-livre-1)
                           deKMSecAntSemAbast             = mab-movto-km-eqpto.val-livre-2.
                END.
                /** Caso houver problemas de contador, deixa mesmo contador no movimento **/
                else do:
                    assign mab-movto-km-eqpto.val-livre-2 = bfKM.val-livre-2
                           deKMSecAntSemAbast             = mab-movto-km-eqpto.val-livre-2.
                end.
            END.
        end.
    END.
    ELSE DO:
        /** Vida Anterior **/
        for last  bfKM fields(val-hodom-horim  bfkm.num-docto val-km-real val-livre-1 val-livre-2 cod-livre-1 val-dat-hora-invrtda)
            where bfKM.ep-codigo            = ttEquipamento.ep-codigo
            and   bfKM.cod-eqpto            = ttEquipamento.cod-eqpto
            and   bfKM.val-dat-hora-invrtda < mab-movto-km-eqpto.val-dat-hora-invrtda no-lock:
            /** Contador maior que contador anterior **/
            IF mab-movto-km-eqpto.val-hodom-horim >= bfKM.val-hodom-horim and 
               bfKM.val-hodom-horim > 0 THEN DO: /* maior que zero para n’o causar erro de cÿlculo do percurso */
                assign mab-movto-km-eqpto.val-km-real = deKMAntSemAbast + (mab-movto-km-eqpto.val-hodom-horim - bfKM.val-hodom-horim)
                       deKMAntSemAbast                = mab-movto-km-eqpto.val-km-real.
            END.
            /** Caso houver problemas de contador, deixa mesmo contador no movimento **/
            else do:
                IF ttEquipamento.idi-tip-eqpto = 1 /*Equipamento Motorizado*/
                THEN DO:
                    assign mab-movto-km-eqpto.val-km-real = bfKM.val-km-real
                           deKMAntSemAbast                = mab-movto-km-eqpto.val-km-real.
                END.
                ELSE DO:
                    assign mab-movto-km-eqpto.val-km-real = deKMAntSemAbast + (mab-movto-km-eqpto.val-km-real - bfKM.val-km-real) /*bfKM.val-km-real*/
                           mab-movto-km-eqpto.val-km-real = IF mab-movto-km-eqpto.val-km-real > 0 THEN mab-movto-km-eqpto.val-km-real ELSE bfKM.val-km-real
                           deKMAntSemAbast                = mab-movto-km-eqpto.val-km-real.
                END.

            end.
            /* Valida‡Æo Contador Secund rio */
            IF  ttEquipamento.log-cont-sec THEN DO:
                /** Contador Secundario maior que contador anterior **/
                /* val-livre-1 referente ao campo val-hodom-horim-sec (Valida‡Æo Contador Secund rio) */
                /* val-livre-2 referente ao campo val-km-real-sec */
                IF mab-movto-km-eqpto.val-livre-1 >= bfKM.val-livre-1 and 
                   bfKM.val-livre-1 > 0 THEN DO: /* maior que zero para n’o causar erro de cÿlculo do percurso */
                    assign mab-movto-km-eqpto.val-livre-2 = deKMSecAntSemAbast + (mab-movto-km-eqpto.val-livre-1 - bfKM.val-livre-1)
                           deKMSecAntSemAbast             = mab-movto-km-eqpto.val-livre-2.
                END.
                /** Caso houver problemas de contador, deixa mesmo contador no movimento **/
                else do:
                    assign mab-movto-km-eqpto.val-livre-2 = bfKM.val-livre-2
                           deKMSecAntSemAbast             = mab-movto-km-eqpto.val-livre-2.
                end.
            END.
        end.
    END.
END.
ELSE DO:
    /** NÆo encontrou hist¢rico, utiliza contador Inicial **/
    IF mab-movto-km-eqpto.val-hodom-horim >= ttEquipamento.val-hodom-horim-inicial THEN DO:
        assign mab-movto-km-eqpto.val-km-real = deKMAntSemAbast + (mab-movto-km-eqpto.val-hodom-horim - ttEquipamento.val-hodom-horim-inicial).
               deKMAntSemAbast                = mab-movto-km-eqpto.val-km-real.
    END.
    /** Contador inicial maior que contador do hist¢rico, deixa mesmo contador no movimento **/
    ELSE DO:
        assign mab-movto-km-eqpto.val-km-real = ttEquipamento.val-km-inicial
               deKMAntSemAbast                = mab-movto-km-eqpto.val-km-real.
    END.
    IF  ttEquipamento.log-cont-sec THEN DO: /* (Valida‡Æo Contador Secund rio ) */
        /** Contador Secundario maior que contador anterior **/
        /* val-livre-1 referente ao campo val-hodom-horim-sec (Valida‡Æo Contador Secund rio) */
        /* val-livre-2 referente ao campo val-km-real-sec */
        /** NÆo encontrou hist¢rico, utiliza contador Inicial **/
        IF mab-movto-km-eqpto.val-livre-1 >= ttEquipamento.val-hodom-horim-inicial THEN DO:
            assign mab-movto-km-eqpto.val-livre-2 = deKMSecAntSemAbast + (mab-movto-km-eqpto.val-livre-1 - ttEquipamento.val-hodom-horim-inicial).
                   deKMSecAntSemAbast             = mab-movto-km-eqpto.val-livre-2.
        END.
        /** Contador Secundario inicial maior que contador do hist¢rico, deixa mesmo contador no movimento **/
        ELSE DO:
            assign mab-movto-km-eqpto.val-livre-2 =  deKMSecAntSemAbast.
        END.
    END.
END.

/******************************************
** 09/08/2006 - Willwock 
** Para corrigir problema de KM Zerado
*****************************************/
if ttEquipamento.idi-tip-eqpto <> 1 THEN
    ASSIGN deKMAnt    = deKMAntSemAbast
           deKMSecAnt = deKMSecAntSemAbast.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piLubrificacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLubrificacao Procedure 
PROCEDURE piLubrificacao :
/*------------------------------------------------------------------------------
  Purpose:     piLubrificacao
  Parameters:  <none>
  Notes:       Atualiza‡Æo Lubrifica‡Æo
------------------------------------------------------------------------------*/
/** Busca a hora atual **/
run piFormataSegundoParaHora (input  time,
                              output cHora).
/** Atualiza o campo hora invertida. Ser  gravado no 
    formato "AAAAMMDDHHMM" (Ano+Mˆs+Dia+Hora+Minuto) **/
run converteParaHoraInvertida (input  string(today,"99/99/9999"),
                               input  string(cHora,"999999"),
                               output deInvertida).

/*    Verifica qual o tipo de contador ser  utilizado para calcular os per¡odos */
/*    de manuten‡Æo das lubrica‡äes.                                            */
/* Valida‡Æo Contador Secund rio */
FOR FIRST mab-param
    WHERE mab-param.cdn-param = 50 NO-LOCK:
    /** 1 = Prim rio 
        2 = Secund rio **/
END.

/** Busca Vida Atual Equipamento **/
for last  mab-movto-km-eqpto fields(val-km-real val-livre-2) USE-INDEX mbmvtkmq-id
    where mab-movto-km-eqpto.ep-codigo             = ttEquipamento.ep-codigo
    and   mab-movto-km-eqpto.cod-eqpto             = ttEquipamento.cod-eqpto
    and   mab-movto-km-eqpto.val-dat-hora-invrtda <= deInvertida no-lock:
end.
/***********************************************
** Diogo - Necessidade de colocar o KM inicial quando nao encontra historico
** Conforme FO n§ 1284.707
***********************************************/
IF AVAIL mab-movto-km-eqpto THEN DO:
    assign deKMAnt = mab-movto-km-eqpto.val-km-real.
END.
ELSE DO:
    ASSIGN deKMAnt = ttEquipamento.val-km-inicial.
END.
/* Valida‡Æo Contador Secund rio */
IF  ttEquipamento.log-cont-sec AND (AVAIL mab-param AND mab-param.des-valor = "2") THEN DO:
    IF AVAIL mab-movto-km-eqpto THEN DO:
        assign deKMAnt = mab-movto-km-eqpto.val-livre-2.
    END.
    ELSE DO:
        ASSIGN deKMAnt = ttEquipamento.val-km-sec.
    END.
END.

/** Percorre per¡odos de manuten‡Æo compartimentos do equipamento **/
for each  mab-period-manut
    where mab-period-manut.ep-codigo = ttEquipamento.ep-codigo
    and   mab-period-manut.cod-eqpto = ttEquipamento.cod-eqpto exclusive-lock:
    /** Busca Apontamento lubrifica‡Æo **/
    FOR last  mab-item-lubrific
        where mab-item-lubrific.ep-codigo      = mab-period-manut.ep-codigo
        and   mab-item-lubrific.cod-eqpto      = mab-period-manut.cod-eqpto
        and   mab-item-lubrific.cod-comptmento = mab-period-manut.cod-comptmento
        and   mab-item-lubrific.cod-evento     = mab-period-manut.cod-evento no-lock:
    END.
    IF  AVAIL mab-item-lubrific THEN DO:
        /** Apontamento Lubrifica‡Æo **/
        for last  mab-item-lubrific fields(num-docto)
            where mab-item-lubrific.ep-codigo      = mab-period-manut.ep-codigo
            and   mab-item-lubrific.cod-eqpto      = mab-period-manut.cod-eqpto
            and   mab-item-lubrific.cod-comptmento = mab-period-manut.cod-comptmento
            and   mab-item-lubrific.cod-evento     = mab-period-manut.cod-evento no-lock:
            /** Busca Status do documento **/
            for first mab-abastec-lubrific fields(num-docto ep-codigo cod-eqpto idi-consist)
                where mab-abastec-lubrific.num-docto = mab-item-lubrific.num-docto no-lock:
                /** Consistido **/
                if mab-abastec-lubrific.idi-consist > 20 then do:
                    for last  mab-movto-km-eqpto fields(val-km-real val-livre-2) USE-INDEX mbmvtkmq-id
                        where mab-movto-km-eqpto.ep-codigo = mab-abastec-lubrific.ep-codigo
                        and   mab-movto-km-eqpto.cod-eqpto = mab-abastec-lubrific.cod-eqpto
                        and   mab-movto-km-eqpto.num-docto = mab-abastec-lubrific.num-docto no-lock:
                        /* Valida‡Æo Contador Secund rio */
                        IF  ttEquipamento.log-cont-sec AND (AVAIL mab-param AND mab-param.des-valor = "2") THEN
                            assign mab-period-manut.val-km-real = deKMAnt - mab-movto-km-eqpto.val-livre-2.
                        ELSE 
                            assign mab-period-manut.val-km-real = deKMAnt - mab-movto-km-eqpto.val-km-real.

                        IF mab-period-manut.val-km-real < 0  THEN 
                           ASSIGN mab-period-manut.val-km-real = 0.
                    end.
                end.
            end.
        end.
    end.
    /** Atualiza pelo inicial do compartimento do equipamento **/
    else do:
        for first mab-comptmento-eqpto 
            where mab-comptmento-eqpto.ep-codigo      = mab-period-manut.ep-codigo
              and mab-comptmento-eqpto.cod-eqpto      = mab-period-manut.cod-eqpto
              and mab-comptmento-eqpto.cod-comptmento = mab-period-manut.cod-comptmento no-lock:

            run converteParaHoraInvertida (input  string(mab-comptmento-eqpto.dat-inicial,"99/99/9999"),
                                           input  "000000",
                                           output deInvertida).
              /* Valida‡Æo Contador Secund rio */
              IF  ttEquipamento.log-cont-sec AND (AVAIL mab-param AND mab-param.des-valor = "2") THEN
                  assign mab-period-manut.val-km-real = deKMAnt - ttEquipamento.val-km-sec + mab-comptmento-eqpto.val-km-inicial.
              ELSE 
                  /** Busca Vida Atual Equipamento **/
                  assign mab-period-manut.val-km-real = deKMAnt - ttEquipamento.val-km-inicial + mab-comptmento-eqpto.val-km-inicial.

              /*---------------------------------------------------------------------------------------------------------*/
              /* Quando compartimento iniciou controle ap¢s o controle do equipamento, busca a £ltima vida do mesmo para */
              /* calcular a vida atual do compartimento                                                                  */
              /*---------------------------------------------------------------------------------------------------------*/
              /* Exemplo:   Equipamento: Vida Inicial = 10.000 km em 01/01/2003.                                         */
              /*                         Vida do equipamento em 04/03/2003 = 47.000 km                                   */
              /*                         Vida do equipamento em 06/03/2003 = 52.000 km.                                  */
              /*                         In¡cio do controle do compartimento em 05/03/2003.                              */
              /*                         O sistema ir  calcular: vida do ¢leo = 52.000 - 47.000, jogando para o          */
              /*                                                 compartimento 5.000 km                                  */
              /*---------------------------------------------------------------------------------------------------------*/                           
                                         
              for last  mab-movto-km-eqpto fields(val-km-real val-livre-2) USE-INDEX mbmvtkmq-id
                  where mab-movto-km-eqpto.ep-codigo             = ttEquipamento.ep-codigo
                  and   mab-movto-km-eqpto.cod-eqpto             = ttEquipamento.cod-eqpto
                  and   mab-movto-km-eqpto.val-dat-hora-invrtda <= deInvertida no-lock:
                  /* Valida‡Æo Contador Secund rio */
                  IF  ttEquipamento.log-cont-sec AND (AVAIL mab-param AND mab-param.des-valor = "2") THEN
                      assign mab-period-manut.val-km-real = deKMAnt - mab-movto-km-eqpto.val-livre-2 + mab-comptmento-eqpto.val-km-inicial.
                  ELSE 
                      assign mab-period-manut.val-km-real = deKMAnt - mab-movto-km-eqpto.val-km-real + mab-comptmento-eqpto.val-km-inicial.
              end.

              IF mab-period-manut.val-km-real < 0  THEN ASSIGN mab-period-manut.val-km-real = 0.
         end.

    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPercursoImplementos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPercursoImplementos Procedure 
PROCEDURE piPercursoImplementos :
/*------------------------------------------------------------------------------
  Purpose:     piPercursoImplementos
  Parameters:  <none>
  Notes:       Atualiza‡Æo quilometragem dos implementos relacionados aos equipamentos.
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pData-Ini AS DATE.
    DEF INPUT PARAM pData-fin AS DATE.
    /*--------------------------------------------------------------------------------------*/
    /* Procedure criada inicialmente para a Empresa Leites L¡der, que assumiu que a carreta */
    /* executa o mesmo percurso que o equipamento na qual a mesma est  alocada              */
    /*--------------------------------------------------------------------------------------*/
    DEFINE BUFFER bfMovtoImp   FOR mab-movto-km-eqpto.
    DEFINE BUFFER bfMovtoImp2  FOR mab-movto-km-eqpto.
    DEFINE BUFFER bfMovtoEqp   FOR mab-movto-km-eqpto.
    DEFINE BUFFER bfImplemento FOR ttEquipamento.
    DEFINE BUFFER bfEqpto      FOR mab-eqpto.

    DEF VAR dValKmAnt AS DECIMAL.
    DEF VAR dValKmSecAnt AS DECIMAL.
    DEF VAR dData-Ini AS DECIMAL.
    DEF VAR dData-Fin AS DECIMAL.
    
    /** Atualiza o campo hora invertida. Ser  gravado no 
        formato "AAAAMMDDHHMM" (Ano+Mˆs+Dia+Hora+Minuto) **/
    run converteParaHoraInvertida (input  string(pData-Ini,"99/99/9999"),
                                   input  "000000",
                                   output dData-Ini).
    run converteParaHoraInvertida (input  string(pData-Fin,"99/99/9999"),
                                   input  "235959",
                                   output dData-Fin).


    /* Excluir quilometragem gerada para implemento no per¡odo */
    FOR EACH bfMovtoEqp WHERE bfMovtoEqp.ep-codigo             = mgf-eqpto-implto.ep-codigo-implto
                          AND bfMovtoEqp.cod-eqpto             = mgf-eqpto-implto.cod-implto
                          AND bfMovtoEqp.val-dat-hora-invrtda  > dData-Fin
                EXCLUSIVE-LOCK:
      FOR FIRST mab-abastec-lubrific EXCLUSIVE-LOCK
            WHERE mab-abastec-lubrific.num-docto = bfMovtoEqp.num-docto :

            ASSIGN mab-abastec-lubrific.idi-consist = 1
                   mab-abastec-lubrific.log-consist = NO. 

                 
        END.
        DELETE bfMovtoEqp.
    END.


    FOR LAST bfMovtoEqp WHERE bfMovtoEqp.ep-codigo = mgf-eqpto-implto.ep-codigo-eqpto
                          AND bfMovtoEqp.cod-eqpto = mgf-eqpto-implto.cod-eqpto
                          AND bfMovtoEqp.val-dat-hora-invrtda < dData-Ini NO-LOCK:
        ASSIGN dValKmAnt    = bfMovtoEqp.val-km-real
               dValKmSecAnt = bfMovtoEqp.val-livre-2.

    END.

    IF NOT AVAIL bfMovtoEqp THEN do:
        FOR FIRST bfEqpto FIELDS (bfEqpto.val-km-inicial bfEqpto.val-km-sec) 
            WHERE bfEqpto.ep-codigo   = mgf-eqpto-implto.ep-codigo-eqpto
              AND bfEqpto.cod-eqpto   = mgf-eqpto-implto.cod-eqpto NO-LOCK:
            ASSIGN dValKmAnt    = bfEqpto.val-km-inicial
                   dValKmSecAnt = bfEqpto.val-km-sec.
        END.
    END.

    FOR EACH bfMovtoEqp WHERE bfMovtoEqp.ep-codigo = mgf-eqpto-implto.ep-codigo-eqpto
                          AND bfMovtoEqp.cod-eqpto = mgf-eqpto-implto.cod-eqpto
                          AND bfMovtoEqp.val-dat-hora-invrtda >= dData-Ini 
                          AND bfMovtoEqp.val-dat-hora-invrtda <= dData-Fin NO-LOCK:
        /*Caso a data do movimento nao esteja dentro eo periodo que o implemento estava associado ao equipamento, o mesmo deve ser ignorado.*/
        IF bfMovtoEqp.dat-movto < mgf-eqpto-implto.dat-inicial THEN  NEXT.

        IF NOT CAN-FIND(FIRST bfMovtoImp WHERE bfMovtoImp.ep-codigo            = mgf-eqpto-implto.ep-codigo-implto
                                           AND bfMOvtoImp.cod-eqpto            = mgf-eqpto-implto.cod-implto
                                           AND bfMOvtoImp.val-dat-hora-invrtda = bfMovtoEqp.val-dat-hora-invrtda) THEN DO:
           CREATE bfMovtoImp.
           BUFFER-COPY bfMovtoEqp EXCEPT log-abastec-prim val-hodom-horim cod-eqpto ep-codigo val-km-real val-livre-1 val-livre-2 TO bfMovtoImp.
           ASSIGN bfMOvtoImp.ep-codigo        = mgf-eqpto-implto.ep-codigo-implto
                  bfMOvtoImp.cod-eqpto        = mgf-eqpto-implto.cod-implto
                  bfMOvtoImp.log-abastec-prim = FALSE 
                  bfMOvtoImp.val-hodom-horim  = 0
                  bfMOvtoImp.val-livre-1      = 0.
        END.
        ELSE DO:
          FOR FIRST bfMovtoImp WHERE bfMovtoImp.ep-codigo            = mgf-eqpto-implto.ep-codigo-implto
                                 AND bfMOvtoImp.cod-eqpto            = mgf-eqpto-implto.cod-implto
                                 AND bfMOvtoImp.val-dat-hora-invrtda = bfMovtoEqp.val-dat-hora-invrtda EXCLUSIVE-LOCK:
          END.
        END.
        
        /*--------------------------------------------------------------------------------------------------------------------*/
        /* Busca £ltima quilometragem calculada para implemento a fim de que possa-se somar o valor do percurso do equipamento */
        /* para o implemento.                                                                                                 */
        /*--------------------------------------------------------------------------------------------------------------------*/
        FOR LAST bfMovtoImp2 FIELDS (val-km-real val-livre-2)
             WHERE bfMovtoImp2.ep-codigo = mgf-eqpto-implto.ep-codigo-implto
               AND bfMovtoImp2.cod-eqpto = mgf-eqpto-implto.cod-implto                   
               AND bfMovtoImp2.val-dat-hora-invrtda < bfMOvtoImp.val-dat-hora-invrtda NO-LOCK:
            ASSIGN bfMovtoImp.val-km-real = bfMovtoImp2.val-km-real + bfMovtoEqp.val-km-real - dValKmAnt
                   bfMovtoImp.val-livre-2 = bfMovtoImp2.val-livre-2 + bfMovtoEqp.val-livre-2 - dValKmSecAnt.
        END.
    
        /*-----------------------------------------------------------------------------------*/
        /* Cria registro em ttEuqipamento (bfImplemento) para que estes implementos tenham o */
        /* per¡odo de uso dos compartimentos e planos de manuten‡Æo preventovas atualizados  */
        /*-----------------------------------------------------------------------------------*/
        IF NOT CAN-FIND (FIRST bfImplemento WHERE bfImplemento.ep-codigo = mgf-eqpto-implto.ep-codigo-implto
                                              AND bfImplemento.cod-eqpto = mgf-eqpto-implto.cod-implto) THEN DO:
            FOR FIRST bfEqpto 
                WHERE bfEqpto.ep-codigo = mgf-eqpto-implto.ep-codigo-implto
                AND bfEqpto.cod-eqpto = mgf-eqpto-implto.cod-implto  NO-LOCK:

                /*------------------------------------------------------------------------------------------------*/
                /* Caso seja primeira atualiza‡Æo de quilometragem do implemento, usa como base o valor informado */
                /* como uso inicial no cadastro do equipamento (no caso o implemento).                            */
                /*------------------------------------------------------------------------------------------------*/
                IF NOT AVAIL bfMovtoImp2 THEN DO:
                    ASSIGN bfMovtoImp.val-km-real = bfEqpto.val-km-inicial + bfMovtoEqp.val-km-real - dValKmAnt
                           bfMovtoImp.val-livre-2 = bfEqpto.val-livre-2 + bfMovtoEqp.val-livre-2 - dValKmSecAnt.
                END.
               
                BUFFER-COPY bfEqpto TO bfImplemento.
                ASSIGN bfImplemento.r-rowid        = ROWID(bfEqpto)
                       bfImplemento.lAtualizaPlano = TRUE.
            END.
        END.
        
        ASSIGN dValKmAnt    = bfMovtoEqp.val-km-real
               dValKmSecAnt = bfMovtoEqp.val-livre-2.
    END.



return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPlanoPreventiva) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPlanoPreventiva Procedure 
PROCEDURE piPlanoPreventiva :
/*------------------------------------------------------------------------------
  Purpose:     piPlanoPreventiva
  Parameters:  <none>
  Notes:       Atualiza‡Æo do uso atual dos planos de manuten‡Æo dos equipamentos.
------------------------------------------------------------------------------*/

/** Percorre per¡odos de manuten‡Æo compartimentos do equipamento **/
blk-plano:
for each  mmv-eqpto-plano
    where mmv-eqpto-plano.ep-codigo = ttEquipamento.ep-codigo
    and   mmv-eqpto-plano.cod-eqpto = ttEquipamento.cod-eqpto exclusive-lock:
    for first mmv-plano-prevent where mmv-plano-prevent.cod-model = ttEquipamento.cod-model
                                  and mmv-plano-prevent.cod-plano = mmv-eqpto-plano.cod-plano no-lock:
    end.

    /****************************************************
    ** Willwock - **   Buscar  o KM conforme a data final do plano
    ****************************************************/    
    run converteParaHoraInvertida (input  string(mmv-eqpto-plano.dat-final,"99/99/9999"),
                                   INPUT  "235959",
                                   output deInvertida).
    /** Busca Vida Atual Equipamento **/
    for last  mab-movto-km-eqpto fields(val-km-real val-livre-2 val-dat-hora-invrtda dat-movto) USE-INDEX mbmvtkmq-id
        where mab-movto-km-eqpto.ep-codigo             = ttEquipamento.ep-codigo
        and   mab-movto-km-eqpto.cod-eqpto             = ttEquipamento.cod-eqpto
        and   mab-movto-km-eqpto.val-dat-hora-invrtda <= deInvertida no-lock:
    end.
    /***********************************************
    ** Willwock - Necessidade de colocar o KM inicial 
    **            quando nao encontra historico
    ***********************************************/
    IF AVAIL mab-movto-km-eqpto THEN DO:
        assign deKMAnt        = mab-movto-km-eqpto.val-km-real.
    END.
    ELSE DO:
        ASSIGN deKMAnt        = ttEquipamento.val-km-inicial.
    END.
    IF ttEquipamento.log-cont-sec THEN DO: /*(Valida‡Æo Contador Secund rio)*/
        IF AVAIL mab-movto-km-eqpto THEN DO:
            assign deKMSecAnt     = mab-movto-km-eqpto.val-livre-2.
        END.
        ELSE DO:
            ASSIGN deKMSecAnt     = ttEquipamento.val-km-sec.
        END.
    END.
    /****************************************************
    ** Willwock - Retirada validacao, pois pode-se ter refeito 
    **            o plano para implementos ou equipamentos sem KM 
    ****************************************************/
    IF NOT AVAIL mmv-plano-prevent /*OR mmv-plano-prevent.val-km-padr = 0 */ THEN NEXT.

    /** Busca a hora atual **/
    run piFormataSegundoParaHora (input  time,
                                  output cHora).
    run converteParaHoraInvertida (input  string(today,"99/99/9999"),
                                   input  string(cHora,"999999"),
                                   output deInvertida).
    /** Busca Apontamento lubrifica‡Æo **/
    if can-find(last  mmv-tar-ord-manut
                where mmv-tar-ord-manut.ep-codigo             = mmv-eqpto-plano.ep-codigo
                and   mmv-tar-ord-manut.cod-eqpto             = mmv-eqpto-plano.cod-eqpto
                and   mmv-tar-ord-manut.cod-plano             = mmv-eqpto-plano.cod-plano 
                AND   mmv-tar-ord-manut.val-dat-invrtda-term <= deInvertida 
                and   mmv-tar-ord-manut.val-dat-invrtda-term > 0 no-lock) then do:

        /** Apontamento Lubrifica‡Æo **/
        for last  mmv-tar-ord-manut fields(val-dat-invrtda-term)
            where mmv-tar-ord-manut.ep-codigo             = mmv-eqpto-plano.ep-codigo
            and   mmv-tar-ord-manut.cod-eqpto             = mmv-eqpto-plano.cod-eqpto
            and   mmv-tar-ord-manut.cod-plano             = mmv-eqpto-plano.cod-plano 
            and   mmv-tar-ord-manut.val-dat-invrtda-term <= deInvertida 
            and   mmv-tar-ord-manut.val-dat-invrtda-term > 0 no-lock:
            
            for last  mab-movto-km-eqpto fields(val-km-real val-livre-2 val-dat-hora-invrtda dat-movto) USE-INDEX mbmvtkmq-id
                where mab-movto-km-eqpto.ep-codigo             = mmv-eqpto-plano.ep-codigo
                  and mab-movto-km-eqpto.cod-eqpto             = mmv-eqpto-plano.cod-eqpto
                  and mab-movto-km-eqpto.val-dat-hora-invrtda <= mmv-tar-ord-manut.val-dat-invrtda-term no-lock:
                  
                  IF  mmv-plano-prevent.log-cont-sec AND ttEquipamento.log-cont-sec THEN /* (Valida‡Æo Contador Secund rio) */
                      assign mmv-eqpto-plano.val-km-real = deKMSecAnt - mab-movto-km-eqpto.val-livre-2.
                  ELSE
                      assign mmv-eqpto-plano.val-km-real = deKMAnt - mab-movto-km-eqpto.val-km-real.

                  IF mmv-eqpto-plano.val-km-real < 0  THEN ASSIGN mmv-eqpto-plano.val-km-real = 0.

                  /********************************************************
                  ** Willwock - Atualizacao da Data em que foi realizado o plano
                  ********************************************************/
                  RUN converteInvertidaParaNormal (INPUT  mmv-tar-ord-manut.val-dat-invrtda-term,
                                                   OUTPUT mmv-eqpto-plano.dat-atualiz,
                                                   OUTPUT cHora).

            end.
        end.
    end.
    /** Atualiza pelo inicial do plano do equipamento **/
    else do:
        run converteParaHoraInvertida (input  string(mmv-eqpto-plano.dat-atualiz,"99/99/9999"),
                                       input  "000000",
                                       output deInvertida).
        /*---------------------------------------------------------------------------------------------------------*/
        /* Quando compartimento iniciou controle ap¢s o controle do equipamento, busca a £ltima vida do mesmo para */
        /* calcular a vida atual do compartimento                                                                  */
        /*---------------------------------------------------------------------------------------------------------*/
        /* Exemplo:   Equipamento: Vida Inicial = 10.000 km em 01/01/2003.                                         */
        /*                         Vida do equipamento em 04/03/2003 = 47.000 km                                   */
        /*                         Vida do equipamento em 06/03/2003 = 52.000 km.                                  */
        /*                         In¡cio do controle do compartimento em 05/03/2003.                              */
        /*                         O sistema ir  calcular: vida do ¢leo = 52.000 - 47.000, jogando para o          */
        /*                                                 compartimento 5.000 km                                  */
        /*---------------------------------------------------------------------------------------------------------*/
        for last  mab-movto-km-eqpto fields(val-km-real val-livre-2 val-dat-hora-invrtda dat-movto) USE-INDEX mbmvtkmq-id
            where mab-movto-km-eqpto.ep-codigo             = ttEquipamento.ep-codigo
            and   mab-movto-km-eqpto.cod-eqpto             = ttEquipamento.cod-eqpto
            and   mab-movto-km-eqpto.val-dat-hora-invrtda <= deInvertida no-lock:

            IF  mmv-plano-prevent.log-cont-sec AND ttEquipamento.log-cont-sec THEN /*(Valida‡Æo Contador Secund rio)*/
                assign mmv-eqpto-plano.val-km-real = deKMSecAnt - mab-movto-km-eqpto.val-livre-2 + mmv-eqpto-plano.val-km-inicial.
            ELSE 
                assign mmv-eqpto-plano.val-km-real = deKMAnt - mab-movto-km-eqpto.val-km-real + mmv-eqpto-plano.val-km-inicial.
            /********************************************************
            ** Willwock - Atualizacao da Data em que foi realizado o plano, caso a data nÆo estiver informada
            ********************************************************/
            IF mmv-eqpto-plano.dat-atualiz = ? THEN
                ASSIGN mmv-eqpto-plano.dat-atualiz = mab-movto-km-eqpto.dat-movto.

        end.
        /************************************************************************
        **  Se nÆo encontrar hist¢rico de KM, atualiza pelo Inicial do Equipamento
        ************************************************************************/
        IF not(AVAIL mab-movto-km-eqpto) THEN DO:
            IF  mmv-plano-prevent.log-cont-sec AND ttEquipamento.log-cont-sec THEN DO: /*(Valida‡Æo Contador Secund rio)*/
                /** Busca Vida Atual Equipamento **/
                assign mmv-eqpto-plano.val-km-real = deKMSecAnt - ttEquipamento.val-km-sec + mmv-eqpto-plano.val-km-inicial.
            END.
            ELSE DO:
                /** Busca Vida Atual Equipamento **/
                assign mmv-eqpto-plano.val-km-real = deKMAnt - ttEquipamento.val-km-inicial + mmv-eqpto-plano.val-km-inicial.
            END.
            /********************************************************
            ** Willwock - Atualizacao da Data em que foi realizado o plano, caso a data nÆo estiver informada
            ********************************************************/
            IF mmv-eqpto-plano.dat-atualiz = ? THEN
                ASSIGN mmv-eqpto-plano.dat-atualiz = ttEquipamento.dDatMovto.
        END.


        IF mmv-eqpto-plano.val-km-real < 0  THEN ASSIGN mmv-eqpto-plano.val-km-real = 0.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

