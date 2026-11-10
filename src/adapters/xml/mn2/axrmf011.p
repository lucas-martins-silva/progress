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
{include/i-prgvrs.i AXRMF011 2.00.00.005 } /*** 010005 ***/


/*****************************************************************************
**
**       PROGRAMA: AMRMF011
**
**       DATA....: 19/07/2007
**
**       AUTOR...: AndrÇ Lu°s O. Pereira / Daniel Marquini - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Adapter Receiver Integraá∆o CTVoicer
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */
{adapters/xml/mn2/axmf.i 'in':U}
{method/dbotterr.i}

{frbo/bofr060.i TTmab-movto-km-eqpto}
{frbo/bofr059.i TTmab-movto-event}
{frbo/bofr010.i TTmab-event}
define variable h-bofr060 as handle     no-undo.
define variable h-bofr059 as handle     no-undo.
define variable h-bofr010 as handle     no-undo.

define temp-table tt-log-import no-undo
    field descricao          as character
    field ajuda              as character.
define input-output parameter table for tt-log-import.

define buffer b-mab-movto-event     for mab-movto-event.
define buffer bf-mab-movto-km-eqpto for mab-movto-km-eqpto.

define variable c-root              as character  no-undo.
define variable c-PeriodAnalyzed    as character  no-undo.
DEFINE VARIABLE de-segundos-horimetro   AS DECIMAL     NO-UNDO.

{utp/ut-glob.i}
{abp/ab9000.i}

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 25.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
assign c-root           = GetRoot().

/* IF tt-element-in.NAME = "EXP_ALARME":U THEN DO:  */
/*     RUN frbo/bofr059.p PERSISTENT SET h-bofr059. */
/*     RUN ExpAlarme.                               */
/*     RETURN RETURN-VALUE.                         */
/* END.                                             */

IF tt-element-in.NAME = "STATISTICS":U THEN DO:
    RUN frbo/bofr060.p PERSISTENT SET h-bofr060.
    RUN Estatistica.
    RETURN RETURN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Estatistica) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Estatistica Procedure 
PROCEDURE Estatistica :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    define variable c-placa                 as character                          no-undo.
    define variable c-data                  as character                          no-undo.
    define variable c-hora                  as character                          no-undo.
    define variable c-data-aux              as character                          no-undo.
    define variable c-hora-aux              as character                          no-undo.
    define variable c-km                    as character                          no-undo.
    define variable c-orimetro              as character                          no-undo.
    define variable de-val-dat-hora-invrtda as decimal    format "999999999999":U no-undo.
    define variable v-val-uso-real          as decimal                            no-undo.
    define variable v-val-uso-real-sec      as decimal                            no-undo.
    
    DEFINE VARIABLE c-num-motor-drives               AS character                          NO-UNDO.
    DEFINE VARIABLE c-num-braking                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-number-drives-parking-brake    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-time-triggered-parking-brake   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-number-drives-sensor1          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-TimeSensor1Triggered           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-NumberDrivesSensor2            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-TimeSensor2Triggered           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-NumberDrivesSensor3            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-TimeSensor3Triggered           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-SpinMediumEngine               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-TimeAnalysisGreenBand          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-TrackTimeInGreen               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-ExcessRotationsLowSpeed        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-ExcessRotationsMaximum         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-ExcessRotationsSubsystem       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-NumberSuddenAccelerations      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-NumberSuddenBraking            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-NumberNeutral                  AS CHARACTER  NO-UNDO.
           
    assign c-PeriodAnalyzed = get(c-root,"PeriodAnalyzed":U).

/*carrega as variaveis com os valores informado no xml*/
assign    c-placa    = (Getsonval(c-root,"Plate":U))
           c-data     = entry(1,Getsonval(c-PeriodAnalyzed,"Until":U)," ")
           c-hora     = entry(2,GetSonval(c-PeriodAnalyzed,"Until":U)," ")
           c-km       = Getsonval(c-root,"TotalKm":U)
           c-orimetro = replace(Getsonval(c-root,"TimeEngineRunning":U),":","").
           
           c-num-motor-drives             = (Getsonval(c-root,"NumberMotorDrives":U)).
           c-num-braking                  = (Getsonval(c-root,"NumberBraking":U)).
           c-number-drives-parking-brake  = (Getsonval(c-root,"NumberDrivesParkingBrake":U)).
           c-time-triggered-parking-brake = (Getsonval(c-root,"TimeTriggeredParkingBrake":U)).
           c-number-drives-sensor1        = (Getsonval(c-root,"NumberDrivesSensor1":U)).
           c-TimeSensor1Triggered         = (Getsonval(c-root,"TimeSensor1Triggered":U)).
           c-NumberDrivesSensor2          = (Getsonval(c-root,"NumberDrivesSensor2":U)).
           c-TimeSensor2Triggered         = (Getsonval(c-root,"TimeSensor2Triggered":U)).
           c-NumberDrivesSensor3          = (Getsonval(c-root,"NumberDrivesSensor3":U)).
           c-TimeSensor3Triggered         = (Getsonval(c-root,"TimeSensor3Triggered":U)).
           c-SpinMediumEngine             = (Getsonval(c-root,"SpinMediumEngine":U)).
           c-TimeAnalysisGreenBand         = (Getsonval(c-root,"TimeAnalysisGreenBand":U)).
           c-TrackTimeInGreen             = (Getsonval(c-root,"TrackTimeInGreen":U)).
           c-ExcessRotationsLowSpeed      = (Getsonval(c-root,"ExcessRotationsLowSpeed":U)).
           c-ExcessRotationsMaximum       = (Getsonval(c-root,"ExcessRotationsMaximum":U)).
           c-ExcessRotationsSubsystem     = (Getsonval(c-root,"ExcessRotationsSubsystem":U)).
           c-NumberSuddenAccelerations    = (Getsonval(c-root,"NumberSuddenAccelerations":U)).
           c-NumberSuddenBraking          = (Getsonval(c-root,"NumberSuddenBraking":U)).
           c-NumberNeutral                = (Getsonval(c-root,"NumberNeutral":U)).


    for first mab-eqpto
        where mab-eqpto.cod-placa = c-placa no-lock:
        
        for first mab-model
            where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            DEFINE VARIABLE c-mensagem AS CHARACTER  NO-UNDO.
            ASSIGN c-mensagem = ?.
            /* faz a verificaá∆o se nenhuma variavel esta com o valor "?" */
         
                

            IF c-placa = ? THEN
                ASSIGN c-mensagem = "placa".

            IF c-data = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", data".
                ELSE 
                    ASSIGN c-mensagem = "data".
                
            IF c-hora = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", hora".
                ELSE 
                    ASSIGN c-mensagem = "hora".

            IF c-km = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", KM".
                ELSE 
                    ASSIGN c-mensagem = "KM".

            IF c-orimetro = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", orimetro".
                ELSE 
                    ASSIGN c-mensagem = "orimetro".

            IF c-num-motor-drives = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", num-motor-drives".
                ELSE 
                    ASSIGN c-mensagem = "num-motor-drives".
            
            

             
            IF c-num-braking = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", num-braking".
                ELSE 
                    ASSIGN c-mensagem = "num-braking".
                
            IF c-number-drives-parking-brake = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", number-drives-parking-brake".
                ELSE 
                    ASSIGN c-mensagem = "number-drives-parking-brake".



            IF c-time-triggered-parking-brake = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", time-triggered-parking-brake".
                ELSE 
                    ASSIGN c-mensagem = "time-triggered-parking-brake".


            IF c-time-triggered-parking-brake = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", time-triggered-parking-brake".
                ELSE 
                    ASSIGN c-mensagem = "time-triggered-parking-brake".


            IF c-number-drives-sensor1 = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", number-drives-sensor1".
                ELSE 
                    ASSIGN c-mensagem = "number-drives-sensor1".


            IF c-TimeSensor1Triggered = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", TimeSensor1Triggered".
                ELSE 
                    ASSIGN c-mensagem = "TimeSensor1Triggered".



            IF c-NumberDrivesSensor2 = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", NumberDrivesSensor2".
                ELSE 
                    ASSIGN c-mensagem = "NumberDrivesSensor2".



            IF c-TimeSensor2Triggered = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", TimeSensor2Triggered".
                ELSE 
                    ASSIGN c-mensagem = "TimeSensor2Triggered".



            IF c-NumberDrivesSensor3 = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", NumberDrivesSensor3".
                ELSE 
                    ASSIGN c-mensagem = "NumberDrivesSensor3".


            IF c-TimeSensor3Triggered = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", c-TimeSensor3Triggered".
                ELSE 
                    ASSIGN c-mensagem = "c-TimeSensor3Triggered".

            IF c-SpinMediumEngine = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", SpinMediumEngine".
                ELSE 
                    ASSIGN c-mensagem = "SpinMediumEngine".


            IF c-TimeAnalysisGreenBand = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", TimeAnalysisGreenBand".
                ELSE 
                    ASSIGN c-mensagem = "TimeAnalysisGreenBand".


            IF c-TrackTimeInGreen = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ", TrackTimeInGreen".
                ELSE 
                    ASSIGN c-mensagem = "TrackTimeInGreen".

            IF c-ExcessRotationsLowSpeed = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ",ExcessRotationsLowSpeed".
                ELSE 
                    ASSIGN c-mensagem = "ExcessRotationsLowSpeed".


            IF c-ExcessRotationsMaximum = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ",ExcessRotationsMaximum".
                ELSE 
                    ASSIGN c-mensagem = "ExcessRotationsMaximum".

                    IF c-ExcessRotationsSubsystem = ? THEN 
            IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ",ExcessRotationsSubsystem".
                ELSE 
                    ASSIGN c-mensagem = "ExcessRotationsSubsystem".

            IF c-NumberSuddenAccelerations = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ",NumberSuddenAccelerations".
                ELSE 
                    ASSIGN c-mensagem = "NumberSuddenAccelerations".

            IF c-NumberSuddenAccelerations = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ",NumberSuddenAccelerations".
                ELSE 
                    ASSIGN c-mensagem = "NumberSuddenAccelerations".


            IF c-NumberSuddenBraking = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ",NumberSuddenBraking".
                ELSE 
                    ASSIGN c-mensagem = "NumberSuddenBraking".


            IF c-NumberNeutral = ? THEN 
                IF c-mensagem <> ? THEN 
                   ASSIGN c-mensagem = c-mensagem + ",NumberNeutral".
                ELSE 
                    ASSIGN c-mensagem = "NumberNeutral".

            IF  c-mensagem = ? THEN DO:
                assign c-hora-aux = replace(c-hora,":","")
                       c-data-aux = string(date(c-data),"99/99/9999")
                       c-km       = string(decimal(replace(c-km,".",","))).
    
                run converteParaHoraInvertida(input  c-data-aux,
                                              input  c-hora-aux,
                                              output de-val-dat-hora-invrtda).
                FIND FIRST mab-movto-km-eqpto
                     WHERE mab-movto-km-eqpto.ep-codigo = mab-eqpto.ep-codigo
                       AND mab-movto-km-eqpto.cod-eqpto = mab-eqpto.cod-eqpto
                       AND mab-movto-km-eqpto.val-dat-hora-invrtda = de-val-dat-hora-invrtda NO-LOCK NO-ERROR.
                IF  AVAIL mab-movto-km-eqpto THEN DO:
                    CREATE tt-log-import.
                    {utp/ut-liter.i "Movimento de Vida do Equipamento j· Existe."}
                    ASSIGN tt-log-import.descricao = RETURN-VALUE.
                    ASSIGN tt-log-import.ajuda     = "".
                    RETURN "NOK":U.
                END.
    
                /** mab-movto-km-eqpto.val-livre-1 = Valor do contador secundario **/
                /** mab-movto-km-eqpto.val-livre-2 = Valor do uso real secundario **/            
                /** Busca ultima kilometragem do equipamento **/
                for last  bf-mab-movto-km-eqpto
                    where bf-mab-movto-km-eqpto.ep-codigo = mab-eqpto.ep-codigo
                      and bf-mab-movto-km-eqpto.cod-eqpto = mab-eqpto.cod-eqpto
                      and bf-mab-movto-km-eqpto.val-dat-hora-invrtda <= de-val-dat-hora-invrtda no-lock:
                end.
    
                /** Cria temp-table de movimento da KM do equipamento **/
                
                create TTmab-movto-km-eqpto.
                assign TTmab-movto-km-eqpto.ep-codigo            = mab-eqpto.ep-codigo
                       TTmab-movto-km-eqpto.cod-eqpto            = mab-eqpto.cod-eqpto
                       TTmab-movto-km-eqpto.idi-origem           = 4
                       TTmab-movto-km-eqpto.log-abastec-prim     = no
                       TTmab-movto-km-eqpto.num-docto            = 0.
    
                /** Se unidade de medida for KM **/
               
                if mab-model.un = "KM":U then do:
                    /** Caso nao exista apontamento anterior Ç usado os valores iniciais do equipamento **/
                    assign TTmab-movto-km-eqpto.val-hodom-horim = decimal(replace(c-km,".",",")) + if avail bf-mab-movto-km-eqpto
                                                                                                   then bf-mab-movto-km-eqpto.val-hodom-horim
                                                                                                   else mab-eqpto.val-hodom-horim-inicial 
                           TTmab-movto-km-eqpto.val-km-real     = decimal(replace(c-km,".",",")) + if avail bf-mab-movto-km-eqpto
                                                                                                   then bf-mab-movto-km-eqpto.val-km-real
                                                                                                   else mab-eqpto.val-km-inicial.
                /*if NOT avail bf-mab-movto-km-eqpto then do:*/
                        for each  mab-movto-km-eqpto
                            where mab-movto-km-eqpto.ep-codigo            = mab-eqpto.ep-codigo
                              and mab-movto-km-eqpto.cod-eqpto            = mab-eqpto.cod-eqpto
                              and mab-movto-km-eqpto.val-dat-hora-invrtda > de-val-dat-hora-invrtda exclusive-lock:
                            if mab-movto-km-eqpto.idi-origem = 4 then
                                assign mab-movto-km-eqpto.val-hodom-horim = mab-movto-km-eqpto.val-hodom-horim + decimal(replace(c-km,".",","))
                                       mab-movto-km-eqpto.val-km-real     = mab-movto-km-eqpto.val-km-real + decimal(replace(c-km,".",",")).
                                /*assign mab-movto-km-eqpto.val-hodom-horim = mab-movto-km-eqpto.val-hodom-horim + TTmab-movto-km-eqpto.val-hodom-horim
                                      mab-movto-km-eqpto.val-km-real     = mab-movto-km-eqpto.val-km-real + TTmab-movto-km-eqpto.val-km-real.*/
                        end.
                    end.
               /* END.*/
                /** Se unidade de medida for Horas **/
                if mab-model.un = "HR":U
                or mab-model.un = "H":U then do:
                    /** A principio converte para segundos e grava apenas o valor informado
                    **  na temp-table para posteriormente somar com o valor anterior **/
                    run piFormataHoraParaSegundo(input  c-orimetro,
                                                 output de-segundos-horimetro).

                    ASSIGN TTmab-movto-km-eqpto.val-hodom-horim = de-segundos-horimetro / 3600.
                    /** Caso nao exista apontamento anterior Ç usado os valores iniciais do equipamento **/


                    /** Calcula o valor real, depois passa para o  calculo do horimetro para acumular corretamento os valores **/
                    ASSIGN TTmab-movto-km-eqpto.val-km-real     = TTmab-movto-km-eqpto.val-hodom-horim + if avail bf-mab-movto-km-eqpto
                                                                                                         then bf-mab-movto-km-eqpto.val-km-real
                                                                                                         else mab-eqpto.val-km-inicial.


                    assign TTmab-movto-km-eqpto.val-hodom-horim = TTmab-movto-km-eqpto.val-hodom-horim + if avail bf-mab-movto-km-eqpto
                                                                                                         then bf-mab-movto-km-eqpto.val-hodom-horim
                                                                                                         else mab-eqpto.val-hodom-horim-inicial.
                    

                    if not avail bf-mab-movto-km-eqpto then do:
                        for each  mab-movto-km-eqpto
                            where mab-movto-km-eqpto.ep-codigo            = mab-eqpto.ep-codigo
                              and mab-movto-km-eqpto.cod-eqpto            = mab-eqpto.cod-eqpto
                              and mab-movto-km-eqpto.val-dat-hora-invrtda > de-val-dat-hora-invrtda exclusive-lock:
                            if mab-movto-km-eqpto.idi-origem = 4 then.
                            assign mab-movto-km-eqpto.val-hodom-horim = mab-movto-km-eqpto.val-hodom-horim + decimal(replace(c-km,".",","))
                                   mab-movto-km-eqpto.val-km-real     = mab-movto-km-eqpto.val-km-real + decimal(replace(c-km,".",",")) .
                        end.
                    end.
                end.
                /** Se for contador secundario **/
                if mab-model.log-cont-sec then do:
                    /** Se unidade de medida for KM **/
                    if mab-model.cod-livre-1 = "KM":U then do:
                        /** Caso nao exista apontamento anterior Ç usado os valores iniciais do equipamento **/
                        assign TTmab-movto-km-eqpto.val-livre-1 = decimal(replace(c-km,".",",")) + if avail bf-mab-movto-km-eqpto
                                                                                                   then bf-mab-movto-km-eqpto.val-livre-1
                                                                                                   else mab-eqpto.val-hodom-horim-sec
                               TTmab-movto-km-eqpto.val-livre-2 = decimal(replace(c-km,".",",")) + if avail bf-mab-movto-km-eqpto
                                                                                                   then bf-mab-movto-km-eqpto.val-livre-2
                                                                                                   else mab-eqpto.val-km-sec.
                       if not avail bf-mab-movto-km-eqpto then do:
                            for each  mab-movto-km-eqpto
                                where mab-movto-km-eqpto.ep-codigo            = mab-eqpto.ep-codigo
                                  and mab-movto-km-eqpto.cod-eqpto            = mab-eqpto.cod-eqpto
                                  and mab-movto-km-eqpto.val-dat-hora-invrtda > de-val-dat-hora-invrtda exclusive-lock:
                                if mab-movto-km-eqpto.idi-origem = 4 THEN.
                                assign mab-movto-km-eqpto.val-livre-1 = mab-movto-km-eqpto.val-livre-1 + decimal(replace(c-km,".",","))
                                       mab-movto-km-eqpto.val-livre-2 = mab-movto-km-eqpto.val-livre-2 + decimal(replace(c-km,".",",")).
                            end.
                        end.
                    end.
                    /** Se unidade de medida for Horas **/
                    if mab-model.cod-livre-1 = "HR":U
                    or mab-model.cod-livre-1 = "H":U then do:
                        /** A principio converte para segundos e grava apenas o valor informado
                        **  na temp-table para posteriormente somar com o valor anterior **/
                        run piFormataHoraParaSegundo(input  c-orimetro,
                                                     output de-segundos-horimetro).

                        ASSIGN TTmab-movto-km-eqpto.val-livre-1 = de-segundos-horimetro / 3600.
                        /** Caso nao exista apontamento anterior Ç usado os valores iniciais do equipamento **/

                        /** Calcula o valor real, depois passa para o  calculo do horimetro para acumular corretamento os valores **/
                        ASSIGN TTmab-movto-km-eqpto.val-livre-1 = TTmab-movto-km-eqpto.val-livre-1 + if avail bf-mab-movto-km-eqpto
                                                                                                     then bf-mab-movto-km-eqpto.val-livre-1
                                                                                                     else mab-eqpto.val-hodom-horim-sec.
                        
                        assign TTmab-movto-km-eqpto.val-livre-2 = TTmab-movto-km-eqpto.val-livre-1 + if avail bf-mab-movto-km-eqpto
                                                                                                     then bf-mab-movto-km-eqpto.val-livre-2
                                                                                                     else mab-eqpto.val-km-sec.
                        if not avail bf-mab-movto-km-eqpto then do:
                            for each  mab-movto-km-eqpto
                                where mab-movto-km-eqpto.ep-codigo            = mab-eqpto.ep-codigo
                                  and mab-movto-km-eqpto.cod-eqpto            = mab-eqpto.cod-eqpto
                                  and mab-movto-km-eqpto.val-dat-hora-invrtda > de-val-dat-hora-invrtda exclusive-lock:
                                if mab-movto-km-eqpto.idi-origem = 4 then.
                                assign mab-movto-km-eqpto.val-livre-1 = mab-movto-km-eqpto.val-livre-1 + decimal(replace(c-km,".",","))
                                       mab-movto-km-eqpto.val-livre-2 = mab-movto-km-eqpto.val-livre-2 + decimal(replace(c-km,".",",")).
                            end.
                        end.
                    end.
                end.
    
                assign c-hora = replace(c-hora,":","")
                       c-data = string(date(c-data),"99/99/9999").
                /*IF LENGTH(c-hora) <> 6 THEN ASSIGN c-hora  = REPLACE(STRING(TIME,"HH:MM:SS":U),":","").*/
                /*IF LENGTH(c-data) <> 10 THEN ASSIGN c-data = STRING(TODAY,"99/99/9999":U).*/
                run converteParaHoraInvertida(input  c-data,
                                              input  c-hora,
                                              output TTmab-movto-km-eqpto.val-dat-hora-invrtda).
     
                assign TTmab-movto-km-eqpto.hra-inicial = c-hora
                       TTmab-movto-km-eqpto.dat-movto   = date(int(entry(2,c-data,"/")),int(entry(1,c-data,"/")),int(entry(3,c-data,"/"))).
    
            END.
            ELSE DO:
                create tt-log-import.
                {utp/ut-liter.i "N∆o_foi_possivel_copiar_arquivo_para_o_servidor."}
                assign tt-log-import.descricao = return-value.
                run utp/ut-liter.p (input "Tag_n∆o_encantrada_no XML." + c-mensagem,
                    input "",
                    input "") no-error.
                /*{utp/ut-liter.i "Tag_n∆o_encantrada_no XML." + c-mensagem}*/
                assign tt-log-import.ajuda = return-value.
                run destroy IN h-bofr060.
                return "NOK":U.
            END.

            
   /** Cria registro da temp-table na BO **/
            run emptyRowErrors in h-bofr060.
            run openQueryStatic in h-bofr060 (input "Main":U) no-error.
            run setRecord in h-bofr060 (input table TTmab-movto-km-eqpto).
            run createRecord in h-bofr060.
            if return-value = "NOK":U then do:
                run getRowErrors IN h-bofr060(output table RowErrors).
                for each RowErrors:
                    create tt-log-import.
                    assign tt-log-import.descricao = RowErrors.ErrorDescription
                           tt-log-import.ajuda     = RowErrors.ErrorHelp.
                    run destroy IN h-bofr060.
                    return "NOK":U.
                end.
            end.
            validate mab-movto-km-eqpto.
        end.
        if not avail mab-model then do:
            create tt-log-import.
            {utp/ut-liter.i "Importaá∆o_de_Hist¢rico_de_Vida"}
            assign tt-log-import.descricao = return-value.
            {utp/ut-liter.i "N∆o_foi_Encontrado_Modelo_do_Equipamento."}
            assign tt-log-import.ajuda = return-value.
            run destroy IN h-bofr060.
            return "NOK":U.
        end.
    end.
    if not avail mab-eqpto then do:
        create tt-log-import.
        {utp/ut-liter.i "Importaá∆o_de_Hist¢rico_de_Vida"}
        assign tt-log-import.descricao = return-value.
        {utp/ut-liter.i "N∆o_foi_Encontrado_Equipamento_com_a_Placa"}
        assign tt-log-import.ajuda = return-value + " " + c-placa .
        run destroy IN h-bofr060.
        return "NOK":U.
    end.
 
  
    run destroy in h-bofr060.
    return "OK":U.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ExpAlarme) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExpAlarme Procedure 
PROCEDURE ExpAlarme :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-placa         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-data          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-hora          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-codigoalarme  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-descricao     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-velocidade    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-geocode       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-excessao      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-cod-grp-event AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-cod-matr      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-cd-tipo       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE c-cod-sub-sist  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE v-cod-grp-event AS CHARACTER  NO-UNDO.

    ASSIGN c-placa        = Getsonval(c-root,"placa":U)
           c-codigoalarme = Getsonval(c-root,"codigo_alarme":U)
           c-descricao    = Getsonval(c-root,"descricao":U)
           c-velocidade   = Getsonval(c-root,"velocidade":U)
           c-geocode      = Getsonval(c-root,"geocode":U)
           c-excessao     = Getsonval(c-root,"excessao":U).

    IF NUM-ENTRIES(Getsonval(c-root,"datahora":U)," ") >=2 THEN DO:
        ASSIGN c-data = ENTRY(1,Getsonval(c-root,"datahora":U)," ")
               c-hora = ENTRY(2,GetSonval(c-root,"datahora":U)," ").
    END.
    ELSE DO:
        CREATE tt-log-import.
        {utp/ut-liter.i "Importaá∆o_de_Eventos"}
        ASSIGN tt-log-import.descricao = RETURN-VALUE.
        {utp/ut-liter.i "Formato_Data/Hora_Inv†lido"}
        ASSIGN tt-log-import.ajuda = RETURN-VALUE.
        RETURN "NOK":U.
    END.
    
    FOR FIRST mab-event NO-LOCK
        WHERE mab-event.cod-evento = c-codigoalarme:
    END.
    IF NOT AVAIL mab-event THEN DO:

        RUN pi-localiza-grupo(INPUT  c-descricao,
                              OUTPUT c-cod-grp-event).
        IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.

        RUN frbo/bofr010.p PERSISTENT SET h-bofr010.
        CREATE TTmab-event.
        ASSIGN TTmab-event.cod-evento    = c-codigoalarme
               TTmab-event.des-Evento    = c-descricao
               TTmab-event.cod-grp-event = c-cod-grp-event.
        RUN emptyRowErrors IN h-bofr010.
        RUN setRecord IN h-bofr010 (INPUT TABLE TTmab-event).
        RUN createRecord IN h-bofr010.
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bofr010(OUTPUT TABLE RowErrors).
            FOR EACH RowErrors:
                CREATE tt-log-import.
                ASSIGN tt-log-import.descricao = RowErrors.ErrorDescription
                       tt-log-import.ajuda     = RowErrors.ErrorHelp.
                RUN destroy IN h-bofr010.
                RETURN "NOK":U.
            END.
        END.
        RUN destroy IN h-bofr010.
        FOR FIRST mab-event NO-LOCK
            WHERE mab-event.cod-evento = c-codigoalarme:
        END.
    END.                                                                                      

    FOR FIRST mab-eqpto NO-LOCK
        WHERE mab-eqpto.cod-placa = c-placa:
        FOR FIRST mab-param NO-LOCK
            WHERE mab-param.cdn-param = 37:
            ASSIGN c-cod-matr = mab-param.des-valor.
        END.
        IF NOT AVAIL mab-param THEN DO:
            CREATE tt-log-import.
            {utp/ut-liter.i "Importaá∆o_de_Eventos"}
            ASSIGN tt-log-import.descricao = RETURN-VALUE.
            {utp/ut-liter.i "Motorista_Padr∆o_n∆o_Encontrado._Verifique_o_Programa_AB0101,_ParÉmetro_37."}
            ASSIGN tt-log-import.ajuda     = RETURN-VALUE.
            RETURN "NOK":U.
        END.

        FOR FIRST mab-param NO-LOCK
            WHERE mab-param.cdn-param = 27:
            ASSIGN c-cd-tipo = INT(mab-param.des-valor).
        END.
        IF NOT AVAIL mab-param THEN DO:
            CREATE tt-log-import.
            {utp/ut-liter.i "Importaá∆o_de_Eventos"}
            ASSIGN tt-log-import.descricao = RETURN-VALUE.
            {utp/ut-liter.i "Tipo_de_Manutená∆o_Padr∆o_n∆o_Encontrado._Verifique_o_Programa_AB0101,_ParÉmetro_27."}
            ASSIGN tt-log-import.ajuda     = RETURN-VALUE.
            RETURN "NOK":U.
        END.

        FOR FIRST mab-param NO-LOCK
            WHERE mab-param.cdn-param = 29:
            ASSIGN c-cod-sub-sist = mab-param.des-valor.
        END.
        IF NOT AVAIL mab-param THEN DO:
            CREATE tt-log-import.
            {utp/ut-liter.i "Importaá∆o_de_Eventos"}
            ASSIGN tt-log-import.descricao = RETURN-VALUE.
            {utp/ut-liter.i "C¢digo_do_SubSistema_Padr∆o_n∆o_Encontrado._Verifique_o_Programa_AB0101,_ParÉmetro_29."}
            ASSIGN tt-log-import.ajuda     = RETURN-VALUE.
            RETURN "NOK":U.
        END.

        FOR LAST b-mab-movto-event NO-LOCK:
        END.

        CREATE TTmab-movto-event.
        ASSIGN TTmab-movto-event.num-docto    = IF AVAIL b-mab-movto-event THEN b-mab-movto-event.num-docto + 1 ELSE 1
               TTmab-movto-event.cod-eqpto    = mab-eqpto.cod-eqpto
               TTmab-movto-event.dat-inicial  = IF LENGTH(c-data) = 10 THEN DATE(INT(ENTRY(2,c-data,"/")),INT(ENTRY(1,c-data,"/")),INT(ENTRY(3,c-data,"/"))) ELSE TODAY
               TTmab-movto-event.dat-final    = TTmab-movto-event.dat-inicial
               TTmab-movto-event.hra-inicial  = c-hora
               TTmab-movto-event.hra-final    = TTmab-movto-event.hra-final
               TTmab-movto-event.cod-evento   = mab-event.cod-evento
               TTmab-movto-event.cod-matr     = c-cod-matr
               TTmab-movto-event.cd-tipo      = c-cd-tipo
               TTmab-movto-event.cod-sub-sist = c-cod-sub-sist
               TTmab-movto-event.cod-usuar    = c-seg-usuario.

        RUN emptyRowErrors IN h-bofr059.
        RUN setRecord IN h-bofr059 (INPUT TABLE TTmab-movto-event).
        RUN createRecord IN h-bofr059.
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bofr059(OUTPUT TABLE RowErrors).
            FOR EACH RowErrors:
                CREATE tt-log-import.
                ASSIGN tt-log-import.descricao = RowErrors.ErrorDescription
                       tt-log-import.ajuda     = RowErrors.ErrorHelp.
                RUN destroy IN h-bofr059.
                RETURN "NOK":U.
            END.
        END.
    END.
    IF NOT AVAIL mab-eqpto THEN DO:
        CREATE tt-log-import.
        {utp/ut-liter.i "Importaá∆o_de_Eventos"}
        ASSIGN tt-log-import.descricao = RETURN-VALUE.
        {utp/ut-liter.i "N∆o_foi_Encontrado_Equipamento_com_a_Placa"}
        ASSIGN tt-log-import.ajuda     = RETURN-VALUE  + " " + c-placa.
        RUN destroy IN h-bofr059.
        RETURN "NOK":U.
    END.

    
    RUN destroy IN h-bofr059.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-localiza-grupo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-localiza-grupo Procedure 
PROCEDURE pi-localiza-grupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-descricao AS CHAR NO-UNDO.

    {utp/ut-liter.i "¢leo"}
    IF p-descricao MATCHES("*" + RETURN-VALUE + "*") THEN DO:
        FOR FIRST mab-grp-event NO-LOCK
            WHERE mab-grp-event.idi-tip = 1:
            RETURN mab-grp-event.cod-grp-event.
        END.
    END.

    {utp/ut-liter.i "oleo"}
    IF p-descricao MATCHES("*" + RETURN-VALUE + "*") THEN DO:
        FOR FIRST mab-grp-event NO-LOCK
            WHERE mab-grp-event.idi-tip = 1:
            RETURN mab-grp-event.cod-grp-event.
        END.
    END.

    {utp/ut-liter.i "filtro"}
    IF p-descricao MATCHES("*" + RETURN-VALUE + "*") THEN DO:
        FOR FIRST mab-grp-event NO-LOCK
            WHERE mab-grp-event.idi-tip = 2:
            RETURN mab-grp-event.cod-grp-event.
        END.
        
    END.

    {utp/ut-liter.i "mecÉnica"}
    IF p-descricao MATCHES("*" + RETURN-VALUE + "*") THEN DO:
        FOR FIRST mab-grp-event NO-LOCK
            WHERE mab-grp-event.idi-tip = 3:
            RETURN mab-grp-event.cod-grp-event.
        END.
    END.

    {utp/ut-liter.i "mecanica"}
    IF p-descricao MATCHES("*" + RETURN-VALUE + "*") THEN DO:
        FOR FIRST mab-grp-event NO-LOCK
            WHERE mab-grp-event.idi-tip = 3:
            RETURN mab-grp-event.cod-grp-event.
        END.
    END.

    {utp/ut-liter.i "motivo"}
    IF p-descricao MATCHES("*" + RETURN-VALUE + "*") THEN DO:
        FOR FIRST mab-grp-event NO-LOCK
            WHERE mab-grp-event.idi-tip = 4:
            RETURN mab-grp-event.cod-grp-event.
        END.
    END.

    {utp/ut-liter.i "parada"}
    IF p-descricao MATCHES("*" + RETURN-VALUE + "*") THEN DO:
        FOR FIRST mab-grp-event NO-LOCK
            WHERE mab-grp-event.idi-tip = 4:
            RETURN mab-grp-event.cod-grp-event.
        END.
    END.

    {utp/ut-liter.i "custo"}
    IF p-descricao MATCHES("*" + RETURN-VALUE + "*") THEN DO:
        FOR FIRST mab-grp-event NO-LOCK
            WHERE mab-grp-event.idi-tip = 5:
            RETURN mab-grp-event.cod-grp-event.
        END.
    END.

    FOR FIRST mab-grp-event NO-LOCK
        WHERE mab-grp-event.idi-tip = 6:
        RETURN mab-grp-event.cod-grp-event.
    END.

    CREATE tt-log-import.
    {utp/ut-liter.i "Importaá∆o_de_Eventos"}
    ASSIGN tt-log-import.descricao = RETURN-VALUE.
    {utp/ut-liter.i "N∆o_foi_poss°vel_localizar_um_Grupo_de_Eventos"}
    ASSIGN tt-log-import.ajuda     = RETURN-VALUE.
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

