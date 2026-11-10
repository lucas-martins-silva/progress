&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0705RP 2.00.00.060 } /*** "010060" 09/09/2025 21:23:07 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0705rp MAB}
&ENDIF


{include/i_fnctrad.i}
/**************************************************************************
**
**       PROGRAMA: AB0705rp.p
**
**       DATA....: 02/03/2005
**
**       AUTOR...: Carlos Valentini - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Importa‡Æo Abastecimentos/Lubrifica‡äes
**
**************************************************************************/
{cdp/cdcfgmnt.i}

/** Defini‡Æo das temp-tables **/
{frbo/bofr055.i ttAbastecLubrific }  /* Temp-table mab-abastec-lubrific */
{frbo/bofr057.i ttitemAbastec }      /* Temp-table mab-item-abastec     */
{frbo/bofr058.i ttItemLubrific }     /* Temp-table mab-item-lubrific    */
{frbo/bofr089.i ttLayout}            /* Temp-table mab-layout-import    */
{frbo/bofr021.i ttPosto}             /* temp-table mab-posto            */

{abp/ab0705.i}
{utp/ut-glob.i}
{cdp/cdcfgman.i} /** Preprocessadores Custeio On-Line **/
{cdp/cdunif001.i} /* 105 - Unifica‡Æo de Conceitos */

{cdp/cd9911.i}

DEFINE  TEMP-TABLE tt-digita no-undo like ttLayout.
define buffer bfRegistros for ttRegistros.
def temp-table tt-raw-digita
   field raw-digita as raw.
/**********************************************************************/
                                               /** Defini‡Æo de Parƒmetros **/   
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
/**********************************************************************/
                    /** Transferˆncia de parƒmetros para temp-table padrÆo **/
create tt-param.
raw-transfer raw-param to tt-param.

for each tt-digita:
  delete tt-digita.
end.

for each tt-raw-digita:
  create tt-digita.
  raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

/**********************************************************************/
                                                /** Defini‡Æo de Vari veis **/
define variable h-acomp             as handle     no-undo.
define variable c-linha             as character  no-undo.
define variable i-cont              as integer    no-undo.
define variable iLinha              as integer    no-undo.
define variable c-aux               as character  no-undo.
define variable i-logical           as integer    no-undo. /** 0 - Falso 1 - Verdadeiro **/
define variable c-lista-campos      as character  no-undo.
define variable hDBOAbastecLubrific as handle     no-undo.
define variable hDBOItemAbastec     as handle     no-undo.
define variable hDBOItemLubrific    as handle     no-undo.
define variable hDBOPosto           as handle     no-undo.
define variable h-ttRegistros       as handle     no-undo. /** Handle da temp-table auxiliar  **/
define variable h-field-ttRegistros as handle     no-undo. /** Handle dos campos da auxiliar **/
define variable l-titulo            as logical    no-undo.
define variable h-abapi007          as handle     no-undo.
define variable hShowMsg            as handle     no-undo.
define stream   s-ab0705.

DEFINE VARIABLE cAtivid           AS CHARACTER  NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
    DEFINE VARIABLE iEmpMatr      LIKE empresa.ep-codigo NO-UNDO.
&ELSE
    DEFINE VARIABLE iEmpMatr      AS INTEGER    NO-UNDO.
&ENDIF
DEFINE VARIABLE cEstabMatr        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMotorista        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTrajeto          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEquipamento      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCusto            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cConta            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iDocto            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNextDocto        AS INTEGER    NO-UNDO.
define VARIABLE dValDataHoraInver as decimal   format "999999999999" no-undo.
DEFINE VARIABLE dValSomaDHI       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cHora             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dData             AS DATE       NO-UNDO.
DEFINE VARIABLE cReturnAux        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cItem             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTpMater          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lLogAbastec       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE deTanque          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iTpManut          AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTroca            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRemonta          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iErro             AS INTEGER    NO-UNDO.
DEFINE VARIABLE cCTCodigo         LIKE  mab-eqpto.ct-codigo  NO-UNDO.
DEFINE VARIABLE cCCcodigo         LIKE mab-eqpto.cc-codigo   NO-UNDO.
DEFINE VARIABLE cCTCodigoLubrific LIKE mab-eqpto.ct-codigo   NO-UNDO.
DEFINE VARIABLE cCCcodigoLubrific LIKE mab-eqpto.cc-codigo   NO-UNDO.
DEFINE VARIABLE cHistEstab        LIKE mab-eqpto.cod-estabel NO-UNDO.
DEFINE VARIABLE cEstab            LIKE mab-posto.cod-estabel NO-UNDO.

DEFINE VARIABLE cContaLub         LIKE mab-eqpto.cod-cta-ctbl-lubrific NO-UNDO.
DEFINE VARIABLE cCustoLub         LIKE mab-eqpto.cod-ccusto-lubrific   NO-UNDO.

define variable iTpContEst        as   integer                no-undo.
define variable dePreco           like mab-item-abastec.val-mater-1 no-undo.
define variable deValor           like mab-item-abastec.val-mater-1 no-undo.
DEFINE VARIABLE iTpValor          AS INTEGER    NO-UNDO.
define variable dePrecoMater      like mab-item-abastec.val-mater-1 no-undo.
DEFINE VARIABLE cAnalise          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iTpPosto AS INTEGER    NO-UNDO. /** 1- interno / 2 - externo **/

DEFINE VARIABLE c-cgc AS CHARACTER  NO-UNDO.
{include/i-rpvar.i}

DEFINE VARIABLE  nombre    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  patente   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  vehiculo  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  tarjeta   AS INTEGER     NO-UNDO.
DEFINE VARIABLE  fecha     AS DATE        NO-UNDO.
DEFINE VARIABLE  hora      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  estacion  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  guia      AS CHAR     NO-UNDO.
DEFINE VARIABLE  unitario  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE  volumen   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE  monto     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE  odometro  AS CHAR        NO-UNDO.
DEFINE VARIABLE  km-Lt     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE  km        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE contItem   AS logica      NO-UNDO.
DEFINE VARIABLE cCodUnidNegoc AS CHARACTER FORMAT "x(3)" NO-UNDO.
/** Altera‡Æo do Status de integra‡Æo com estoque **/
DEFINE BUFFER   bf-mab-abastec-lubrific FOR mab-abastec-lubrific.

DEFINE VARIABLE cDescComb AS CHARACTER FORMAT "x(1)" NO-UNDO.

def temp-table tt_cta_integr no-undo
   field ttv_cod_plano_cta_ctbl as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
   field ttv_cod_cta_ctbl as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
   field ttv_des_titulo as character format "x(40)"
   field ttv_num_tip_cta_ctbl as integer format ">9" label "Tipo Conta" column-label "Tipo Conta"
   field ttv_num_sit_cta_ctbl as integer format ">9" label "Situa‡Æo Conta" column-label "Situa‡Æo Cta"
   field ttv_ind_finalid_ctbl_cta as character format "X(40)" label "Finalidade Cont bil"
   index tt_id                           
         ttv_cod_plano_cta_ctbl           ascending
         ttv_cod_cta_ctbl                 ascending
   .

DEFINE VARIABLE c-erro-financeiro AS CHARACTER NO-UNDO.
/*** Inicio Projeto 118 - Seguran‡a por Estabelecimento ***/
{cdp/cd0031.i "MAB":U} /** Trigger on-fin da tabela estabelec **/
/*** Final Projeto 118 - Seguran‡a por Estabelecimento ***/

/**********************************************************************/
                                                     /** Cabe‡alho e Forms **/

DEFINE VARIABLE i-cont55 AS INTEGER initial 0   NO-UNDO.

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
         HEIGHT             = 22.25
         WIDTH              = 39.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
{abp/abapi001.i2} /** Cria‡Æo de erros **/
{abp/ab9000.i}    /** ConversÆo de horas **/
{abp/ab9001.i}    /** Busca valores alternativos **/
/** Parametriza padräes de cabe‡alho e rodap‚ a serem exibidos **/
run piInicial in this-procedure.
{utp/ut-liter.i "Linha:" }
assign c-aux = trim(return-value).
/** Imprime cabe‡alho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i &TOFILE=tt-param.arq-destino}  /** Abertura do output do programa **/

/** Procedure para inicializar c lculos e impressÆo **/
run piPrincipal in this-procedure.

/** Fecha o output para arquivo **/
{include/i-rpclo.i}

return "OK":U. 
/*--- Fim do Programa ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-atualizaTTRegistros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaTTRegistros Procedure 
PROCEDURE atualizaTTRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/** Busca parƒmetros quando campos nÆo onformados deve-se usar o valor do padrÆo **/
for each  mab-param no-lock
    where mab-param.cdn-param = 37
    or    mab-param.cdn-param = 38
    or    mab-param.cdn-param = 21
    or    mab-param.cdn-param = 17
    or    mab-param.cdn-param = 18
    or    mab-param.cdn-param = 10 
    or    mab-param.cdn-param = 40:
    if  mab-param.cdn-param = 37 then do:
        IF  mab-param.des-valor <> "" THEN DO:
            assign iEmpMatr = &IF "{&mguni_version}" >= "2.071" &THEN entry(1, mab-param.des-valor, ",") &ELSE int(entry(1, mab-param.des-valor, ",")) &ENDIF
                   cEstabMatr = entry(2, mab-param.des-valor, ",")
                   cMotorista = entry(3, mab-param.des-valor, ",").
        END.
    end.
    if mab-param.cdn-param  = 38 then
        assign cTrajeto   =  mab-param.des-valor.
    if mab-param.cdn-param  = 21 then 
        assign iTpManut   = int(mab-param.des-valor).
    if mab-param.cdn-param  = 17 then 
        assign cTroca     = mab-param.des-valor.
    if mab-param.cdn-param  = 18 then 
        assign cRemonta   =  mab-param.des-valor.
    if mab-param.cdn-param  = 10 then 
        assign iTpValor = int(mab-param.des-valor).
    if mab-param.cdn-param  = 40 then 
        assign cAnalise = mab-param.des-valor.
END.


IF tt-param.iLayout = 3 THEN DO:
    IF NOT CAN-FIND(FIRST tt_cta_integr)
    THEN DO:
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
        EMPTY TEMP-TABLE tt_log_erro.
    
        RUN pi_busca_ctas_integr IN h_api_cta_ctbl (INPUT "",
                                                    INPUT "CEP",
                                                    INPUT "",
                                                    INPUT "(nenhum)",
                                                    INPUT TODAY,
                                                    OUTPUT TABLE tt_cta_integr,
                                                    OUTPUT TABLE tt_log_erro).
    
        DELETE OBJECT h_api_cta_ctbl.
    END.
END.

for each ttRegistros exclusive-lock
    break by ttRegistros.iLinha:
    ASSIGN ttRegistros.cod-mater = ttRegistros.cod-tip-mater.
    
    if ttRegistros.tipo = 2 then
        assign ttRegistros.tipo = 2.
    else
        assign ttRegistros.tipo = 1.

    
    {utp/ut-liter.i "Linha" * }
    RUN pi-Acompanhar IN h-acomp (return-value + ": " + string(ttRegistros.iLinha)).
    case tt-param.iLayout:
        when 1 then
            run piTTRegistrosGoodCard in this-procedure. /**GoodCard**/
        when 2 then
            run piTTRegistrosCTF in this-procedure. /**CTF **/
        when 3 then
            run piTTRegistrosOutros in this-procedure. /** PadrÆo Datasul **/
        when 4 THEN DO:
            IF ttRegistros.iLinha = 1 THEN 
                run piTTRegistrosCopec in this-procedure. /** Copec **/
        END.
    end CASE.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buscaMaterial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaMaterial Procedure 
PROCEDURE buscaMaterial :
/*------------------------------------------------------------------------------
  Purpose:     buscaMaterial
  Parameters:  input pi-tipo = Tipo de Buscar (1 = C¢digo, 2 = Descri‡Æo, 3 = PadrÆo)
  Notes:       Busca qual o Material aplicado no Abastecimento/Lubrifica‡Æo
------------------------------------------------------------------------------*/
define input parameter pi-tipo as integer no-undo.

define variable l-ok as logical no-undo.

assign l-ok = no.

case pi-tipo:
    when 1 then do:
        run buscaMaterialCodigo in this-procedure.
        if return-value = "OK":U then assign l-ok = yes.
        else run buscaMaterial in this-procedure (2).
    end.
    when 2 then do:
        run buscaMaterialDescricao in this-procedure.
        if return-value = "OK":U then assign l-ok = yes.
        else run buscaMaterial in this-procedure (3).
    end.
    when 3 then do:
               /** Se busca Valores Padräes **/
        if tt-param.lValoresPadr then do:
            if ttRegistros.Tipo = 1 then do: /** Abastecimento **/
                /** Busca o hist¢rico do combustivel (Com Consumo) do Equipamento **/
                for first mab-histor-combust 
                    where mab-histor-combust.ep-codigo      = ttRegistros.ep-codigo
                    and   mab-histor-combust.cod-eqpto      = ttRegistros.cod-eqpto
                    and   mab-histor-combust.idi-tip-consu  > 1 
                    and   mab-histor-combust.dat-inicial   <= ttRegistros.dat-movto
                    AND  (mab-histor-combust.dat-desativ    >= ttRegistros.dat-movto 
                          OR mab-histor-combust.dat-desativ  = ?)  NO-LOCK:

                    assign ttRegistros.cod-mater = mab-histor-combust.cod-tip-mater
                           l-ok                 = yes.
                end.
            end. /** fim busca Abastecimento **/
            else do: /**Lubrifica‡Æo **/
                if can-find(first mab-comptmento-eqpto 
                            where mab-comptmento-eqpto.ep-codigo      = ttRegistros.ep-codigo               
                            and   mab-comptmento-eqpto.cod-eqpto      = ttRegistros.cod-eqpto               
                            and   mab-comptmento-eqpto.cod-comptmento = ttRegistros.cod-comptmento no-lock) then do:
                   for first mab-comptmento-eqpto 
                       where mab-comptmento-eqpto.ep-codigo      = ttRegistros.ep-codigo         
                       and   mab-comptmento-eqpto.cod-eqpto      = ttRegistros.cod-eqpto no-lock:
                       assign ttRegistros.cod-mater = mab-comptmento-eqpto.cod-tip-mater
                              l-ok                 = yes.
                   end.
                 END.
            end.
            for last RowErrorsAux no-lock:
                assign iErro = RowErrorsAux.ErrorSequence.
            end.

            {utp/ut-liter.i Material_atualizado_pelos_padräes * }
            create RowErrorsAux.
            assign RowErrorsAux.ErrorSequence     = iErro + 1
                   RowErrorsAux.ErrorNumber       = 0
                   RowErrorsAux.i-Linha           = ttRegistros.ilinha
                   RowErrorsAux.ErrorDescription  = return-value
                   RowErrorsAux.ErrorSubType      = "":U.
        end.
    end.
end case.
if l-ok then do:
   blk-item:
   /** Busca o item do tipo de material **/
   for each mab-tip-mater-item fields (cod-tip-mater it-codigo)
       where mab-tip-mater-item.cod-tip-mater = trim(ttRegistros.cod-mater) no-lock:
       if iTpPosto = 1 then do:  /** Posto interno **/           
          if can-find (first item 
                       where item.it-codigo   = mab-tip-mater-item.it-codigo 
                       AND   ITEM.cod-obsoleto = 1
                       and   item.tipo-contr <> 4 no-lock) then do:
                assign ttRegistros.it-codigo = mab-tip-mater-item.it-codigo.
                leave blk-item.
          end.

       end.
       else do: /** Posto externo **/
          if can-find (first item 
                       where item.it-codigo  = mab-tip-mater-item.it-codigo 
                       AND   ITEM.cod-obsoleto = 1
                       and   item.tipo-contr = 4 no-lock) then do:
                assign ttRegistros.it-codigo = mab-tip-mater-item.it-codigo.
                leave blk-item.
          end.
       end.
   end. /**do for each **/
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buscaMaterialCodigo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaMaterialCodigo Procedure 
PROCEDURE buscaMaterialCodigo :
/*------------------------------------------------------------------------------
  Purpose:     buscaMaterialCodigo
  Parameters:  <none>
  Notes:       Busca o Tipo de Material por c¢digo
------------------------------------------------------------------------------*/
/** Busca o Tipo de Material por C¢digo **/
for first mab-tip-mater 
    where mab-tip-mater.cod-tip-mater = ttRegistros.cod-mater no-lock:
end.
if avail mab-tip-mater then do:
   if ttRegistros.Tipo = 1 then do: /** Abastecimento **/
        /** Busca o hist¢rico do combustivel (Com Consumo) do Equipamento **/
        if not can-find(first mab-histor-combust 
                    where mab-histor-combust.ep-codigo      = ttRegistros.ep-codigo
                    and   mab-histor-combust.cod-eqpto      = ttRegistros.cod-eqpto
                    and   mab-histor-combust.idi-tip-consu  > 1 
                    and   mab-histor-combust.dat-inicial   <= ttRegistros.dat-movto
                    and   mab-histor-combust.cod-tip-mater  = ttRegistros.cod-mater no-lock) then do:
            return "NOK":U.
        end.
   end. /** fim busca Abastecimento **/
   else do: /**Lubrifica‡Æo **/
       if can-find(first mab-comptmento-eqpto 
                   where mab-comptmento-eqpto.ep-codigo      = ttRegistros.ep-codigo               
                   and   mab-comptmento-eqpto.cod-eqpto      = ttRegistros.cod-eqpto               
                   and   mab-comptmento-eqpto.cod-comptmento = ttRegistros.cod-comptmento no-lock) then do:
           if not can-find(first mab-comptmento-eqpto 
                           where mab-comptmento-eqpto.ep-codigo     = ttRegistros.ep-codigo               
                           and   mab-comptmento-eqpto.cod-eqpto     = ttRegistros.cod-eqpto               
                           and   mab-comptmento-eqpto.cod-tip-mater = ttRegistros.cod-mater no-lock) then do:
                return "NOK":U.
           end.
       END.
       ELSE return "NOK":U.
   end.
end.
ELSE DO:
    IF  tt-param.iLayout = 3 AND iTpPosto = 2 AND ttRegistros.it-codigo = "" AND ttRegistros.cod-mater = "" THEN DO:
        IF  ttRegistros.Tipo = 1 THEN DO: /** Abastecimento **/
            /** Busca o hist¢rico do combustivel (Com Consumo) do Equipamento **/
            FIND FIRST mab-histor-combust
                 WHERE mab-histor-combust.ep-codigo      = ttRegistros.ep-codigo
                 AND   mab-histor-combust.cod-eqpto      = ttRegistros.cod-eqpto
                 AND   mab-histor-combust.idi-tip-consu  > 1
                 AND   mab-histor-combust.dat-inicial   <= ttRegistros.dat-movto
                 AND  (mab-histor-combust.dat-desativ    >= ttRegistros.dat-movto 
                       OR mab-histor-combust.dat-desativ  = ?)  NO-LOCK NO-ERROR.
            IF  AVAIL mab-histor-combust THEN DO:
                ASSIGN ttRegistros.cod-mater = mab-histor-combust.cod-tip-mater.
            END.
            ELSE RETURN "NOK":U.
        END. /** fim busca Abastecimento **/
        ELSE DO: /**Lubrifica‡Æo **/
            FIND FIRST mab-comptmento-eqpto
                 WHERE mab-comptmento-eqpto.ep-codigo      = ttRegistros.ep-codigo
                 AND   mab-comptmento-eqpto.cod-eqpto      = ttRegistros.cod-eqpto
                 AND   mab-comptmento-eqpto.cod-comptmento = ttRegistros.cod-comptmento NO-LOCK NO-ERROR.
            IF  AVAIL mab-comptmento-eqpto THEN DO:
                ASSIGN ttRegistros.cod-mater = mab-comptmento-eqpto.cod-tip-mater.
            END.
            ELSE RETURN "NOK":U.
        END.
    END.
    ELSE RETURN "NOK":U.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buscaMaterialDescricao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaMaterialDescricao Procedure 
PROCEDURE buscaMaterialDescricao :
/*------------------------------------------------------------------------------
  Purpose:     buscaMaterialCodigo
  Parameters:  <none>
  Notes:       Busca o Tipo de Material por c¢digo
------------------------------------------------------------------------------*/
/** Busca o Tipo de Material por C¢digo **/
for first mab-tip-mater 
    where mab-tip-mater.des-tip-mater = trim(ttRegistros.des-tip-mater) no-lock:
end.
if avail mab-tip-mater then do:
   if ttRegistros.Tipo = 1 then do: /** Abastecimento **/
        /** Busca o hist¢rico do combustivel (Com Consumo) do Equipamento **/
        if not can-find(first mab-histor-combust 
                    where mab-histor-combust.ep-codigo      = ttRegistros.ep-codigo
                    and   mab-histor-combust.cod-eqpto      = ttRegistros.cod-eqpto
                    and   mab-histor-combust.idi-tip-consu  > 1 
                    and   mab-histor-combust.dat-inicial   <= ttRegistros.dat-movto
                    and   mab-histor-combust.cod-tip-mater  = mab-tip-mater.cod-tip-mater no-lock) then do:
            return "NOK":U.
        end.
   end. /** fim busca Abastecimento **/
   else do: /**Lubrifica‡Æo **/
       if can-find(first mab-comptmento-eqpto 
                   where mab-comptmento-eqpto.ep-codigo      = ttRegistros.ep-codigo               
                   and   mab-comptmento-eqpto.cod-eqpto      = ttRegistros.cod-eqpto               
                   and   mab-comptmento-eqpto.cod-comptmento = ttRegistros.cod-comptmento no-lock) then do:
           if not can-find(first mab-comptmento-eqpto 
                           where mab-comptmento-eqpto.ep-codigo     = ttRegistros.ep-codigo               
                           and   mab-comptmento-eqpto.cod-eqpto     = ttRegistros.cod-eqpto               
                           and   mab-comptmento-eqpto.cod-tip-mater = mab-tip-mater.cod-tip-mater no-lock) then do:
                return "NOK":U.
           end.
       END.
       ELSE return "NOK":U.
   end.
   /** Guarda o Tipo de Material **/
   assign ttRegistros.cod-mater = mab-tip-mater.cod-tip-mater.
end.
ELSE return "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayDados Procedure 
PROCEDURE displayDados :
/*------------------------------------------------------------------------------
  Purpose:     displayDados
  Parameters:  <none>
  Notes:       Mostra os dados da importa‡Æo e seus respectivos erros.
------------------------------------------------------------------------------*/
    
IF tt-param.iLayout = 4 AND contItem = NO THEN DO:
   FOR EACH ttRegistros NO-LOCK:
       ASSIGN contItem = YES.
       IF NOT CAN-FIND(FIRST RowErrorsAux
               WHERE RowErrorsAux.i-linha = ttRegistros.ilinha NO-LOCK) THEN DO:
           {utp/ut-liter.i Registro_atualizado_sem_Erros. }
           create RowErrorsAux.
           assign RowErrorsAux.ErrorSequence     = iErro
                  RowErrorsAux.ErrorNumber       = 0
                  RowErrorsAux.i-Linha           = ttRegistros.ilinha
                  RowErrorsAux.ErrorDescription  = return-value
                  RowErrorsAux.ErrorSubType      = "":U.
       END.
   END.
END.

{utp/ut-liter.i "Imprimindo Dados da Importa‡Æo" * }
RUN pi-Acompanhar IN h-acomp (return-value).

/** Imprime os erros gen‚ricos **/
for each  RowErrorsAux
    where RowErrorsAux.i-Linha = 0 no-lock
    by    RowErrorsAux.ErrorSequence:

    display RowErrorsAux.ErrorSequence   
            RowErrorsAux.ErrorNumber     
            RowErrorsAux.ErrorDescription format "x(60)"
        with frame f-erro.
    down with frame f-erro.
end.

/** Mostra t¡tulo dos dados **/
if (tt-param.todos = 1 or can-find(first RowErrorsAux no-lock)) and
    can-find(first ttRegistros no-lock) THEN DO:
    PAGE.
    view frame f-titulo.
END.

for each  ttRegistros 
    where ttRegistros.dat-movto >= tt-param.dtInicial   
    and   ttRegistros.dat-movto <= tt-param.dtFinal 
    and   ttRegistros.cod-placa >= tt-param.placaIni
    and   ttRegistros.cod-placa <= tt-param.placaFim
    and   ttRegistros.ep-codigo >= tt-param.empIni      
    and   ttRegistros.ep-codigo <= tt-param.empFim      
    and   ttRegistros.cod-eqpto >= tt-param.eqptoIni    
    and   ttRegistros.cod-eqpto <= tt-param.eqptoFim  NO-LOCK
    by    ttRegistros.iLinha:

    IF tt-param.iLayout = 3 AND l-usa-unid-negoc THEN DO:
        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF NOT(ttRegistros.cod-unid-negoc >= tt-param.unidNegocIni  AND 
                   ttRegistros.cod-unid-negoc <= tt-param.unidNegocFim) THEN NEXT.
        &ENDIF
    END.

    /** Imprime Todos os registros **/
    if tt-param.todos = 1 then do:
        /** Imprime Abastecimentos **/
        display ttRegistros.iLinha
                ttRegistros.ep-codigo
                ttRegistros.cod-eqpto
                ttRegistros.dat-movto
                ttRegistros.cod-placa
            with frame f-km.
        if can-find(first RowErrorsAux
                    where RowErrorsAux.i-Linha = ttRegistros.iLinha no-lock) then
            /** Imprime Erros **/
            for each  RowErrorsAux
                where RowErrorsAux.i-Linha = ttRegistros.iLinha no-lock
                by    RowErrorsAux.ErrorNumber:
                display RowErrorsAux.ErrorNumber  at 63   
                        RowErrorsAux.ErrorDescription format "x(58)"
                    with frame f-km.
                down with frame f-km.
            end.
        else down with frame f-km.
    end.
    /** Imprime somente os com erro **/
    else
        /** Verifica se linha cont‚m erros **/
        if can-find(first RowErrorsAux
                    where RowErrorsAux.i-Linha = ttRegistros.iLinha no-lock) then do:
           /** Imprime Abastecimentos **/
            display ttRegistros.iLinha   
                    ttRegistros.ep-codigo 
                    ttRegistros.cod-eqpto 
                    ttRegistros.dat-movto 
                    ttRegistros.cod-placa 
                with frame f-km.
            /** Imprime Erros **/
            for each  RowErrorsAux
                where RowErrorsAux.i-Linha     = ttRegistros.iLinha
               /* and   RowErrorsAux.ErrorNumber <> 0 */ no-lock
                by    RowErrorsAux.ErrorNumber:
                display RowErrorsAux.ErrorNumber  at 63    
                        RowErrorsAux.ErrorDescription format "x(58)"
                    with frame f-km.
                down with frame f-km.
            end.
        end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayParametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayParametros Procedure 
PROCEDURE displayParametros :
/*------------------------------------------------------------------------------
  Purpose:     displayParametros
  Parameters:  <none>
  Notes:       Mostra os parƒmetros selecionados
------------------------------------------------------------------------------*/
/** NÆo mostra frame de t¡tulo dos dados **/
hide frame f-titulo.
/** Cria a p gina dos parƒmetros **/
page.

/***************************************************************
  Final do espa‡o reservado
***************************************************************/
&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN cUnidNegocIni = tt-param.unidNegocIni
           cUnidNegocFim = tt-param.unidNegocFim.

    IF NOT l-usa-unid-negoc THEN
        ASSIGN cFaixa     = "":U
               c-liter-un = "":U.
&ENDIF

DISPLAY /*PAR¶METRO*/
        c-liter-par
        tt-param.arq-entrada
        /*SELE€ÇO*/
        c-liter-sel
        tt-param.dtInicial  
        tt-param.dtFinal    
        tt-param.empIni     
        tt-param.empFim     
        tt-param.eqptoIni   
        tt-param.eqptoFim   
        tt-param.placaIni   
        tt-param.placaFim
        &IF DEFINED(bf_mnt_ems206b) &THEN
        c-liter-un
        cUnidNegocIni 
        cUnidNegocFim
        cFaixa
        &ENDIF
        /*LOG*/
        c-liter-log
        c-imprime
        c-destino 
        c-execucao         
        tt-param.arq-destino
        tt-param.usuario   
        tt-param.iLayout  
        tt-param.iImport  
        tt-param.iClassif
        tt-param.cLayout  
        tt-param.cImport 
        tt-param.cClassif
    WITH FRAME f-param-definidos.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-finalizaHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE finalizaHandle Procedure 
PROCEDURE finalizaHandle :
/*------------------------------------------------------------------------------
  Purpose:     finalizaHandle
  Parameters:  <none>
  Notes:       Elimina da mem¢ria o handle ds BOS
------------------------------------------------------------------------------*/

    run finalizaHandle in hDBOAbastecLubrific NO-ERROR.
    run finalizaHandle in hDBOItemAbastec     NO-ERROR.
    run finalizaHandle in hDBOItemLubrific    NO-ERROR.

    if valid-handle(hDBOAbastecLubrific) THEN
        run Destroy in hDBOAbastecLubrific.

    if valid-handle(hDBOItemAbastec) THEN   
        run Destroy in hDBOItemAbastec.

    if valid-handle(hDBOItemLubrific) THEN   
        run Destroy in hDBOItemLubrific.

    return "ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-inicializaHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaHandle Procedure 
PROCEDURE inicializaHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*:T--- BO da tabela mab-abastec-lubrific ---*/
     IF NOT VALID-HANDLE(hDBOAbastecLubrific) OR
        hDBOAbastecLubrific:TYPE <> "PROCEDURE":U OR
        hDBOAbastecLubrific:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
        run frbo/bofr055.p persistent set hDBOAbastecLubrific.
     END.
     RUN openQueryStatic IN hDBOAbastecLubrific (INPUT "Main":U) NO-ERROR.
     
 /*:T--- BO da tabela item do abastecimento ---*/
     IF NOT VALID-HANDLE(hDBOItemAbastec) OR
        hDBOItemAbastec:TYPE <> "PROCEDURE":U OR
        hDBOItemAbastec:FILE-NAME <> "frbo/bofr057.p":U THEN DO:
        run frbo/bofr057.p persistent set hDBOItemAbastec.
     END.
     RUN openQueryStatic IN hDBOItemAbastec (INPUT "Main":U) NO-ERROR.

     /*:T--- BO da tabela item da lubrifica‡Æo ---*/
     IF NOT VALID-HANDLE(hDBOItemLubrific) OR
        hDBOItemLubrific:TYPE <> "PROCEDURE":U OR
        hDBOItemLubrific:FILE-NAME <> "frbo/bofr058.p":U THEN DO:
        run frbo/bofr058.p persistent set hDBOItemLubrific.
     END.
     RUN openQueryStatic IN hDBOItemLubrific (INPUT "Main":U) NO-ERROR.

     
     /*:T--- BO da tabela item da lubrifica‡Æo ---*/
     IF NOT VALID-HANDLE(hDBOPosto) OR
        hDBOPosto:TYPE <> "PROCEDURE":U OR
        hDBOPosto:FILE-NAME <> "frbo/bofr021.p":U THEN DO:
        run frbo/bofr021.p persistent set hDBOPosto.
     END.
     RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

     
     /** Verifica se Consiste Ficha **/
     for first mab-param
         where mab-param.cdn-param = 11 no-lock:
         /** 1 = On-Line / 2 = Batch **/
         if mab-param.des-valor = "1":U then do:
             /*--- Seta a BO para executar a API ABAPI001 (Consistˆncia das Fichas) ---*/
             run setaExecutaAPI in hDBOItemAbastec  (input yes).
             run setaExecutaAPI in hDBOItemLubrific (input yes).
         END.
         else do:
             run setaExecutaAPI in hDBOItemAbastec  (input no).
             run setaExecutaAPI in hDBOItemLubrific (input no).
         END.
     END.
     RUN inicializaHandle in hDBOAbastecLubrific NO-ERROR.
     RUN inicializaHandle in hDBOItemAbastec     NO-ERROR.
     RUN inicializaHandle in hDBOItemLubrific    NO-ERROR.
 
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAdicionaMinutos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAdicionaMinutos Procedure 
PROCEDURE piAdicionaMinutos :
/*------------------------------------------------------------------------------
  Purpose:     piAdicionaMinutos
  Parameters:  <none>
  Notes:       Procedure criada por Diogo Maia para poder somar o valor de tela
               com a datahorainvertida.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pDataHoraInvert AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pMintosAdd      AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER pSomaDHI        AS DECIMAL    NO-UNDO.

DEFINE VARIABLE dcDhi       AS DECIMAL   FORMAT "999999999999"  NO-UNDO.
DEFINE VARIABLE dcDhiADD    AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cDhi        AS CHARACTER FORMAT "999999999999"  NO-UNDO.
DEFINE VARIABLE cDhiAno     AS CHARACTER FORMAT "9999"          NO-UNDO.
DEFINE VARIABLE iDhiAno     AS INTEGER                          NO-UNDO.
DEFINE VARIABLE cDhiMes     AS CHARACTER FORMAT "99"            NO-UNDO.
DEFINE VARIABLE iDhiMes     AS INTEGER   FORMAT "99"            NO-UNDO.
DEFINE VARIABLE cDhiMesAux  AS CHARACTER FORMAT "99"            NO-UNDO.
DEFINE VARIABLE cDhiDia     AS CHARACTER FORMAT "99"            NO-UNDO.
DEFINE VARIABLE iDhiDia     AS INTEGER   FORMAT "99"            NO-UNDO.
DEFINE VARIABLE iDhiDiaAux  AS INTEGER   FORMAT "99"            NO-UNDO.
DEFINE VARIABLE cDhiHora    AS CHARACTER FORMAT "99"            NO-UNDO.
DEFINE VARIABLE iDhiHora    AS INTEGER   FORMAT "99"            NO-UNDO.
DEFINE VARIABLE cDhiMin     AS CHARACTER FORMAT "99"            NO-UNDO.
DEFINE VARIABLE iDhiMin     AS INTEGER   FORMAT "99"            NO-UNDO.
DEFINE VARIABLE iMinAdd     AS INTEGER   FORMAT "99"            NO-UNDO.
DEFINE VARIABLE iMinAddAux  AS INTEGER   FORMAT "999"           NO-UNDO.

ASSIGN dcDhi   = pDataHoraInvert
       cDhi    = STRING(dcDhi,"999999999999")
       iMinAdd = tt-param.iAgrupa. /** Colocar **/

/** quebra o parƒmetro pDataHoraInvert em v rias vari veis  **/
ASSIGN cDhiAno    = SUBSTRING(cDhi,1,4)
       iDhiAno    = INT(cDhiAno)
       cDhiMes    = SUBSTRING(cDhi,5,2)
       iDhiMes    = INT(cDhiMes)
       cDhiDia    = SUBSTRING(cDhi,7,2)
       iDhiDia    = INT(cDhiDia)
       cDhiHora   = SUBSTRING(cDhi,9,2)
       iDhiHora   = INT(cDhiHora)
       cDhiMin    = SUBSTRING(cDhi,11,2)
       iDhiMin    = INTEGER(cDhiMin)
       iMinAddAux = iDhiMin + iMinAdd. /** Soma minutos existentes + quantidade informada em tela **/

/** Se (minutos existentes + quantidade informada em tela) > 59 **/
IF iMinAddAux > 59 THEN DO:
    /** incrementa a hora e calcula a quantidade de minutos - 60 **/
    ASSIGN iDhiHora = INTEGER(cDhiHora) + 1
           iDhiMin  = iMinAddAux - 60.
END.
/** Se o minuto menor ou igual a 59 **/
ELSE DO:
    /** Se (minutos existentes + quantidade informada em tela) < 60 
        entÆo adiciona os minutos informados em tela aos minutos existentes **/
    ASSIGN iDhiMin  = iDhiMin + iMinAdd.
END.
/** Se a hora for maior que 23 **/
IF iDhiHora > 23 THEN DO:
    /** Incrementa o dia e zera e zera a hora **/
    ASSIGN iDhiDia    = INTEGER(cDhiDia) + 1
           iDhiHora   = 00
           cDhiMesAux = cDhiMes  /** Vari vel para verifica‡Æo posterior do Mˆs **/
           iDhiDiaAux = iDhiDia. /** Vari vel para verifica‡Æo posterior do Dia **/
    
    /** Caso o mˆs seja **/
    CASE cDhiMesAux:
        /** Janeiro **/
        WHEN "01" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 31 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Fevereiro **/
        WHEN "02" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 28 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Mar‡o **/
        WHEN "03" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 31 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Abril **/
        WHEN "04" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 30 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Maio **/
        WHEN "05" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 31 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Junho **/
        WHEN "06" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 30 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Julho **/
        WHEN "07" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 31 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Agosto **/
        WHEN "08" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 31 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Setembro **/
        WHEN "09" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 30 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Outubro **/
        WHEN "10" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 31 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Novembro **/
        WHEN "11" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 30 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiMes = INTEGER(cDhiMes) + 1
                       iDhiDia = 01.
            END.
        END.
        /** Dezembro **/
        WHEN "12" THEN DO:
            /** Se for o £ltimo dia do mˆs **/
            IF iDhiDiaAux > 31 THEN DO:
                /** Incrementa o mˆs e deixa o dia como sendo o primeiro dia do mˆs **/
                ASSIGN iDhiAno = iDhiAno + 1
                       iDhiMes = 01
                       iDhiDia = 01.
            END.
        END.
    END CASE.
END.

ASSIGN cDhiAno  = STRING(iDhiAno)
       cDhiMes  = STRING(iDhiMes,"99")
       cDhiDia  = STRING(iDhiDia,"99")
       cDhiHora = STRING(iDhiHora,"99")
       cDhiMin  = STRING(iDhiMin,"99").

/** Monta valor do parƒmetro que ser  retornado **/
ASSIGN pSomaDHI = DECIMAL(STRING(cDhiAno + cDhiMes + cDhiDia + cDhiHora + cDhiMin)).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAgrupoAbastecimentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAgrupoAbastecimentos Procedure 
PROCEDURE piAgrupoAbastecimentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE  deValDataHora like mab-abastec-lubrific.val-dat-hora-invrtda    NO-UNDO.
assign deValDataHora = 0.00.

DEFINE VARIABLE dt-Aux  AS DATE      FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE hr-Aux  AS CHARACTER FORMAT "99:99:99"   NO-UNDO.
DEFINE VARIABLE dhi-Aux LIKE mab-abastec-lubrific.val-dat-hora-invrtda NO-UNDO.
DEFINE VARIABLE km-Aux  LIKE mab-abastec-lubrific.val-hodom-horim      NO-UNDO.

/** Somente agrupa se tiver minutos informados **/
IF tt-param.iAgrupa > 0 THEN DO:
    {utp/ut-liter.i "Agrupando Abastecimentos" * }
    RUN pi-Acompanhar IN h-acomp (return-value).

    for each ttRegistros 
		where ttRegistros.log-erro-segur = false
		use-index valdatahora exclusive-lock:
		
        /** Registros Agrupados nÆo devem ser lidos novamente **/
        if ttRegistros.l-agrupa  = yes then next.
		
		&IF "{&mguni_version}" >= "2.071" &THEN
			if ttRegistros.ep-codigo = "" and  ttRegistros.cod-eqpto = "":U then next.
		&ELSE
			if ttRegistros.ep-codigo = 0 and  ttRegistros.cod-eqpto = "":U then next.
		&ENDIF

        RUN piAdicionaMinutos (INPUT  ttRegistros.valDatHorInvert,
                               INPUT  tt-param.iagrupa,
                               OUTPUT dValSomaDHI).

        assign deValDataHora = dValSomaDHI
               dt-Aux  = ttRegistros.dat-movto
               hr-Aux  = ttRegistros.hra-inicial
               dhi-Aux = ttRegistros.valDatHorInvert
               km-Aux  = ttRegistros.val-hodom-horim.

        if tt-param.iLayout = 1 or tt-param.iLayout = 3 then do: /** GoodCard ou PadrÆo **/

            if ttRegistros.Tipo = 1 then do: /** Abastecimento **/

                /** J  existe registro nesta data e hora para o posto e equipamento e mesmo tipo de material , entÆo soma o
                anterior com o atual e elimina um dos registros **/
                /** Busca Registro **/
                for each bfRegistros use-index valdatahora
                    where bfRegistros.ep-codigo       = ttRegistros.ep-codigo
                    and   bfRegistros.cod-eqpto       = ttRegistros.cod-eqpto
                    and   bfRegistros.cod-mater       = ttRegistros.cod-mater
                    and   bfRegistros.cod-posto       = ttRegistros.cod-posto
                    AND   bfRegistros.cod-bomba       = ttRegistros.cod-bomba
                    and   bfRegistros.valDatHorInvert >= ttRegistros.valDatHorInvert
                    and   bfRegistros.valDatHorInvert <= deValDataHora
                    and   bfRegistros.l-agrupa        = no
                    and   rowid(bfRegistros)         <> rowid(ttRegistros) exclusive-lock:

					&IF "{&mguni_version}" >= "2.071" &THEN
						if bfRegistros.ep-codigo = "" and  bfRegistros.cod-eqpto = "":U then next.
					&ELSE
						if bfRegistros.ep-codigo = 0 and  bfRegistros.cod-eqpto = "":U then next.
					&ENDIF

                    /** Acumula abastecimentos **/
                    assign ttRegistros.val-quant    = ttRegistros.val-quant    + bfRegistros.val-quant
                           ttRegistros.val-mater-1  = ttRegistros.val-mater-1  + bfRegistros.val-mater-1
                           ttRegistros.val-mater-2  = ttRegistros.val-mater-2  + bfRegistros.val-mater-2
                           ttRegistros.val-mater-3  = ttRegistros.val-mater-3  + bfRegistros.val-mater-3
                           ttRegistros.l-agrupa     = NO
                           bfRegistros.l-agrupa     = YES
                           dt-Aux  = bfRegistros.dat-movto
                           hr-Aux  = bfRegistros.hra-inicial
                           dhi-Aux = bfRegistros.valDatHorInvert
                           km-Aux  = bfRegistros.val-hodom-horim.

                    /** Busca £ltimo erro criado na BO **/
                    for last RowErrorsAux no-lock:
                        assign iErro = RowErrorsAux.ErrorSequence.
                    END.

                    {utp/ut-liter.i Registro_acumulado_a_linha: }
                    create RowErrorsAux.
                    assign RowErrorsAux.ErrorSequence     = iErro
                           RowErrorsAux.ErrorNumber       = 0
                           RowErrorsAux.i-Linha           = bfRegistros.ilinha
                           RowErrorsAux.ErrorDescription  = return-value + " ":U + string(ttRegistros.ilinha)
                           RowErrorsAux.ErrorSubType      = "":U.
                END.
            END.

            else do: /** Lubrifica‡Æo **/
                     /** J  existe registro nesta data e hora para o posto e equipamento e mesmo tipo de material , entÆo soma o
                         anterior com o atual e elimina um dos registros **/
                /** Busca Registro **/
                for each bfRegistros
                    where bfRegistros.ep-codigo       = ttRegistros.ep-codigo
                    and   bfRegistros.cod-eqpto       = ttRegistros.cod-eqpto
                    and   bfRegistros.cod-mater       = ttRegistros.cod-mater
                    and   bfRegistros.cod-posto       = ttRegistros.cod-posto
                    and   bfRegistros.cod-comptmento  = ttRegistros.cod-comptmento
                    and   bfRegistros.cod-evento      = ttRegistros.cod-evento
                    and   bfRegistros.valDatHorInvert >= ttRegistros.valDatHorInvert
                    and   bfRegistros.valDatHorInvert <= deValDataHora
                    and   bfRegistros.l-agrupa        = no
                    and   rowid(bfRegistros)         <> rowid(ttRegistros) exclusive-lock:

					&IF "{&mguni_version}" >= "2.071" &THEN
						if    bfRegistros.ep-codigo = "" and  bfRegistros.cod-eqpto = "":U then next.
					&ELSE
						if    bfRegistros.ep-codigo = 0 and  bfRegistros.cod-eqpto = "":U then next.
					&ENDIF

                    /** Acumula abastecimentos **/
                    assign ttRegistros.val-quant    = ttRegistros.val-quant    + bfRegistros.val-quant
                           ttRegistros.val-mater-1  = ttRegistros.val-mater-1  + bfRegistros.val-mater-1
                           ttRegistros.val-mater-2  = ttRegistros.val-mater-2  + bfRegistros.val-mater-2
                           ttRegistros.val-mater-3  = ttRegistros.val-mater-3  + bfRegistros.val-mater-3
                           ttRegistros.l-agrupa     = NO
                           bfRegistros.l-agrupa     = YES
                           dt-Aux  = bfRegistros.dat-movto
                           hr-Aux  = bfRegistros.hra-inicial
                           dhi-Aux = bfRegistros.valDatHorInvert
                           km-Aux  = bfRegistros.val-hodom-horim.

                    /** Busca £ltimo erro criado na BO **/
                    for last RowErrorsAux no-lock:
                        assign iErro = RowErrorsAux.ErrorSequence.
                    END.

                    {utp/ut-liter.i Registro_acumulado_a_linha: }
                    create RowErrorsAux.
                    assign RowErrorsAux.ErrorSequence     = iErro
                           RowErrorsAux.ErrorNumber       = 0
                           RowErrorsAux.i-Linha           = bfRegistros.ilinha
                           RowErrorsAux.ErrorDescription  = return-value + " ":U + string(ttRegistros.ilinha)
                           RowErrorsAux.ErrorSubType      = "":U.
                END.
            END.
        END.

        else do: /** CTF Ser  sempre abastecimento**/
                 /** J  existe registro nesta data e hora para o posto e equipamento e mesmo tipo de material/compartimento , entÆo soma o
                     anterior com o atual e elimina um dos registros **/
                 /** Busca Registro **/
            for each bfRegistros
                where bfRegistros.ep-codigo       = ttRegistros.ep-codigo
                and   bfRegistros.cod-eqpto       = ttRegistros.cod-eqpto
                and   bfRegistros.cod-mater       = ttRegistros.cod-mater
                and   bfRegistros.cod-posto       = ttRegistros.cod-posto
                and   bfRegistros.valDatHorInvert >= ttRegistros.valDatHorInvert
                and   bfRegistros.valDatHorInvert <= deValDataHora
                and   bfRegistros.l-agrupa        = no
                and   rowid(bfRegistros)         <> rowid(ttRegistros) exclusive-lock:

				&IF "{&mguni_version}" >= "2.071" &THEN
					if    bfRegistros.ep-codigo = "" and  bfRegistros.cod-eqpto = "":U then next.
				&ELSE
					if    bfRegistros.ep-codigo = 0 and  bfRegistros.cod-eqpto = "":U then next.
				&ENDIF

                /** Acumula abastecimentos **/
                assign ttRegistros.val-quant    = ttRegistros.val-quant    + bfRegistros.val-quant
                       ttRegistros.val-mater-1  = ttRegistros.val-mater-1  + bfRegistros.val-mater-1
                       ttRegistros.val-mater-2  = ttRegistros.val-mater-2  + bfRegistros.val-mater-2
                       ttRegistros.val-mater-3  = ttRegistros.val-mater-3  + bfRegistros.val-mater-3
                       ttRegistros.l-agrupa     = NO
                       bfRegistros.l-agrupa     = YES
                       dt-Aux  = bfRegistros.dat-movto
                       hr-Aux  = bfRegistros.hra-inicial
                       dhi-Aux = bfRegistros.valDatHorInvert
                       km-Aux  = bfRegistros.val-hodom-horim.

                /** Busca éltimo erro criado na BO **/
                for last RowErrorsAux no-lock:
                    assign iErro = RowErrorsAux.ErrorSequence.
                END.

                {utp/ut-liter.i Registro_acumulado_a_linha: }
                create RowErrorsAux.
                assign RowErrorsAux.ErrorSequence     = iErro
                       RowErrorsAux.ErrorNumber       = 0
                       RowErrorsAux.i-Linha           = bfRegistros.ilinha
                       RowErrorsAux.ErrorDescription  = return-value + " ":U + string(ttRegistros.ilinha)
                       RowErrorsAux.ErrorSubType      = "":U.

            END.
        END.

        IF ttRegistros.valDatHorInvert < dhi-Aux THEN DO:
            ASSIGN ttRegistros.dat-movto       = dt-Aux
                   ttRegistros.hra-inicial     = hr-Aux
                   ttRegistros.valDatHorInvert = dhi-Aux
                   ttRegistros.val-hodom-horim = km-Aux.
        END.
    END.
END.

return "Ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAlteraParaNaoIntegrado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAlteraParaNaoIntegrado Procedure 
PROCEDURE piAlteraParaNaoIntegrado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Valida‡äes para alterar para nÆo integrado o documento **/
DEFINE BUFFER bf-mab-posto FOR mab-posto.
DEFINE BUFFER bf-mab-tip-mater FOR mab-tip-mater.
DEFINE BUFFER bf-mab-tip-mater-item FOR mab-tip-mater-item.
DEFINE BUFFER bf-ITEM FOR ITEM.

/** Busca Posto de Abastecimento **/                                                                             
FOR FIRST bf-mab-posto FIELD (idi-posto)                                                                         
    WHERE bf-mab-posto.cod-posto = ttRegistros.cod-posto NO-LOCK:                                                
END.                                                                                                             
/** Posto pr¢prio **/                                                                                            
IF AVAIL bf-mab-posto AND bf-mab-posto.idi-posto    = 1 THEN DO:                                                 
    blk-item-valida-tp-mater-lubrific:                                                                           
    FOR FIRST bf-mab-tip-mater  FIELD(log-integr dat-livre-1)                                                    
         WHERE bf-mab-tip-mater.cod-tip-mater = ttRegistros.cod-tip-mater NO-LOCK:                               
         /** Valida‡Æo para saber se a Data de Movimento ‚ menor que a data do in¡cio do controle **/            
         IF ttRegistros.dat-movto < bf-mab-tip-mater.dat-livre-1 THEN NEXT.                                      
         /** Valida o item do movimento, se for d‚bito direto desconsidera **/                                   
         IF ttRegistros.it-codigo <> "" THEN DO:                                                                 
             FOR FIRST bf-ITEM FIELD(tipo-contr)                                                                 
                 WHERE bf-ITEM.it-codigo = ttRegistros.it-codigo NO-LOCK:                                        
             END.                                                                                                
             IF AVAIL bf-ITEM AND bf-ITEM.tipo-contr = 4 THEN NEXT.                                              
         END.                                                                                                    
         ELSE DO:                                                                                                
             /** Busca o item do tipo de material **/                                                            
             FOR EACH bf-mab-tip-mater-item fields (cod-tip-mater it-codigo)                                     
                 WHERE bf-mab-tip-mater-item.cod-tip-mater = TRIM(ttRegistros.cod-mater) NO-LOCK:                
                 IF CAN-FIND (FIRST bf-ITEM                                                                      
                              WHERE bf-ITEM.it-codigo   = bf-mab-tip-mater-item.it-codigo                        
                              AND   bf-ITEM.tipo-contr <> 4 NO-LOCK) then do:                                    
                       LEAVE blk-item-valida-tp-mater-lubrific.                                                  
                 END.                                                                                            
             END.                                                                                                
         END.                                                                                                    
         /****************************************                                                               
         ** Caso tenha sido integrado, coloca ficha como nÆo integrada                                           
         *****************************************/                                                              
         IF bf-mab-tip-mater.log-integr THEN DO:                                                                 
             FIND CURRENT bf-mab-abastec-lubrific EXCLUSIVE-LOCK NO-ERROR.                                       
             ASSIGN bf-mab-abastec-lubrific.idi-integr = 1.                                                      
             FIND CURRENT bf-mab-abastec-lubrific NO-LOCK NO-ERROR.                                              
         END.
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaAbastecLubrific) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaAbastecLubrific Procedure 
PROCEDURE piCriaAbastecLubrific :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /** Deve limpara a temp-table para evitar erros**/
    empty temp-table ttAbastecLubrific.

   /** Cria temp-table **/
    create ttAbastecLubrific.
    assign  ttAbastecLubrific.cc-codigo             = ttRegistros.cc-codigo
            ttAbastecLubrific.cod-ativid            = ttRegistros.cod-ativid
            ttAbastecLubrific.cod-eqpto             = ttRegistros.cod-eqpto
            ttAbastecLubrific.ep-codigo-matr        = ttRegistros.ep-codigo-matr
            ttAbastecLubrific.cod-estabel-matr      = ttRegistros.cod-estabel-matr
            ttAbastecLubrific.cod-matr              = ttRegistros.cod-matr
            ttAbastecLubrific.cod-posto             = ttRegistros.cod-posto
            ttAbastecLubrific.dat-movto             = ttRegistros.dat-movto
            ttAbastecLubrific.ep-codigo             = ttRegistros.ep-codigo 
            ttAbastecLubrific.hra-inicial           = ttRegistros.hra-inicial
            ttAbastecLubrific.hra-final             = ttRegistros.hra-inicial
            ttAbastecLubrific.nr-nota-fis           = ttRegistros.nr-nota-fis
            ttAbastecLubrific.num-docto             = iDocto
            ttAbastecLubrific.ct-codigo             = ttRegistros.ct-codigo
            ttAbastecLubrific.val-dat-hora-invrtda  = ttRegistros.valDatHorInvert
            ttAbastecLubrific.val-hodom-horim       = ttRegistros.val-hodom-horim
            ttAbastecLubrific.cod-emitente          = ttRegistros.cod-emitente   
        &IF DEFINED(bf_mnt_ems206b) &THEN
            ttAbastecLubrific.cod-unid-negoc        = ttRegistros.cod-unid-negoc 
        &ELSE
            ttAbastecLubrific.cod_unid_negoc        = ttRegistros.cod_unid_negoc 
        &ENDIF
            ttAbastecLubrific.cod-usuar             = ttRegistros.cod-usuar      
            ttAbastecLubrific.ct-codigo             = ttRegistros.ct-codigo      
            ttAbastecLubrific.serie                 = ttRegistros.serie
            ttAbastecLubrific.cod-rota              = ttRegistros.cod-rota
            ttAbastecLubrific.cod-cta-ctbl-lubrific = ttRegistros.ct-codigo-ficha-lubrific
            ttAbastecLubrific.cod-ccusto-lubrific   = ttRegistros.cc-codigo-ficha-lubrific.

    IF tt-param.iLayout = 4 THEN DO:
        ASSIGN ttAbastecLubrific.cod-usuar-alter    = ttRegistros.cod-usuar
               ttAbastecLubrific.dat-origin         = ttRegistros.dat-origin
               ttAbastecLubrific.dsl-obs            = ttRegistros.dsl-obs. 
    END.

    FOR FIRST mab-eqpto
        WHERE mab-eqpto.cod-eqpto = ttAbastecLubrific.cod-eqpto
          AND mab-eqpto.ep-codigo = ttAbastecLubrific.ep-codigo NO-LOCK:
        IF mab-eqpto.log-cont-sec THEN
            ASSIGN ttAbastecLubrific.val-hodom-horim-sec = ttRegistros.val-hodom-horim-sec.
        ELSE 
            ASSIGN ttAbastecLubrific.val-hodom-horim-sec = 0.
    END.

    /*--- Limpa temp-table RowErrors no DBO ---*/
    RUN emptyRowErrors IN hDBOAbastecLubrific.
    /*--- Transfere temp-table tt-requisicao para o DBO ---*/
    RUN setRecord IN hDBOAbastecLubrific (INPUT TABLE ttAbastecLubrific).
    /*--- Altera o registro corrente do DBO ---*/
    RUN createRecord IN hDBOAbastecLubrific.
    /*--- Atualiza vari vel cReturnAux com o conte£do do RETURN-VALUE ---*/
    ASSIGN cReturnAux = RETURN-VALUE.
      

    /*--- Verifica ocorrˆncia de erros durante a grava‡Æo ---*/

    IF cReturnAux = "NOK":U THEN DO:
          /*--- Retorna temp-table RowErrors do DBO ---*/
          RUN getRowErrors IN hDBOAbastecLubrific (OUTPUT TABLE RowErrors).
          
          IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
              RUN buscadocumento IN hDBOAbastecLubrific (OUTPUT iNextDocto).
              IF iNextDocto <> ttAbastecLubrific.num-docto THEN DO:
                  EMPTY TEMP-TABLE ttAbastecLubrific.
                  RUN buscadocumento IN hDBOAbastecLubrific(OUTPUT idocto).
                  RUN piCriaAbastecLubrific.
              END.
          END.

          assign iErro = 0.
          /** Elimina todos os erros intrnos da BO (Navega»’o) **/
          for each  RowErrors
              where RowErrors.ErrorSubType = "INTERNAL":U exclusive-lock:
              delete RowErrors.
          end.
          /** Busca £ltimo erro criado na BO **/
          for last RowErrorsAux no-lock:
              assign iErro = RowErrorsAux.ErrorSequence.
          end.
          /** Percorre os erros da BO **/
          for each RowErrors no-lock:
              /** Cria erros na BO **/

              create RowErrorsAux.
              buffer-copy RowErrors except RowErrors.ErrorSequence to RowErrorsAux
                  /** Coloca sequ¼ncia **/
                  assign RowErrorsAux.ErrorSequence = iErro + 1
                         RowErrorsAux.i-Linha       = ttRegistros.ilinha.
              assign iErro = RowErrorsAux.ErrorSequence.
          end.
    end.
    
    IF CAN-FIND(FIRST RowErrorsAux 
                WHERE (RowErrorsAux.ErrorSubType = "ERROR":U 
                OR     RowErrorsAux.ErrorSubType = "":U) 
                AND    RowErrorsAux.i-linha      = ttRegistros.ilinha
                AND    RowErrorsAux.ErrorNumber  > 0) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaErroAux) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaErroAux Procedure 
PROCEDURE piCriaErroAux :
/*------------------------------------------------------------------------------
  Purpose:     piCriaErroAux
  Parameters:  entrada pMens  = N£mero da Mensagem
               entrada pLinha = N£mero da linha do registro
               entrada pParam = Parƒmetros para Mensagem
  Notes:       Cria‡Æo dos erros auxiliares (para cada linha do arquivo)
------------------------------------------------------------------------------*/
define input parameter pMens  as integer   no-undo.
define input parameter pLinha as integer   no-undo.
define input parameter pParam as character no-undo.


/** Cria a Mensagem pela procedure padrÆo **/
run piCriaErro in this-procedure (input pMens,
                                  input "PROGRESS":U,
                                  input pParam).
/** Cria a auxiliar informando a linha que ocorreu o erro **/

create RowErrorsAux.
buffer-copy RowErrors to RowErrorsAux
    assign RowErrorsAux.i-linha = pLinha.


/** Limpa a temp-normal **/
empty temp-table RowErrors.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaItemAbastec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaItemAbastec Procedure 
PROCEDURE piCriaItemAbastec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
run buscaTipoMaterial in hDBOItemAbastec (input  ttRegistros.ep-codigo ,
                                          input  ttRegistros.cod-eqpto,
                                          input  ttRegistros.it-codigo,
                                          input  ttRegistros.dat-movto,
                                          output cTpMater,
                                          output lLogAbastec,
                                          output deTanque).

/** Deve limpara a temp-table para evitar erros**/
empty temp-table ttitemAbastec.

create ttitemAbastec.
assign ttitemAbastec.cod-bomba                = ttRegistros.cod-bomba
       ttitemAbastec.cod-eqpto                = ttRegistros.cod-eqpto
       ttitemAbastec.cod-posto                = ttRegistros.cod-posto 
       ttitemAbastec.cod-tip-mater            = IF ttRegistros.cod-mater <> "" THEN ttRegistros.cod-mater ELSE cTpMater 
       ttitemAbastec.ep-codigo                = ttRegistros.ep-codigo 
       ttitemAbastec.it-codigo                = ttRegistros.it-codigo
       ttitemAbastec.log-abastec-prim         = lLogAbastec
       ttitemAbastec.num-docto                = iDocto
       ttitemAbastec.val-dat-hora-invrtda     = ttRegistros.valDatHorInvert
       ttitemAbastec.val-mater-1              = ttRegistros.val-mater-1
       ttitemAbastec.val-mater-2              = ttRegistros.val-mater-2
       ttitemAbastec.val-mater-3              = ttRegistros.val-mater-3
       ttitemAbastec.val-quant                = ttRegistros.val-quant
       ttitemAbastec.cod-refer                = ttRegistros.cod-refer
       ttitemAbastec.cod-localiz              = ttRegistros.cod-localiz
       ttitemAbastec.lote                     = ttRegistros.lote
       ttitemAbastec.cod-cta-ctbl             = ttRegistros.ct-codigo-abastec
       ttitemAbastec.cod-ccusto               = ttRegistros.cc-codigo-abastec.

IF tt-param.iLayout = 4 THEN DO:
    ASSIGN ttitemAbastec.log-abastec-prim   =  ttRegistros.log-abastec-prim
           ttitemAbastec.nr-trans           =  0.
END.

  assign cReturnAux = "":U.
  /*--- Limpa temp-table RowErrors no DBO ---*/
  RUN emptyRowErrors IN hDBOItemAbastec.
  /*--- Transfere temp-table tt-requisicao para o DBO ---*/
  RUN setRecord IN hDBOItemAbastec (INPUT TABLE ttitemAbastec).
  /*--- Altera o registro corrente do DBO ---*/
  RUN createRecord IN hDBOItemAbastec.
  /*--- Atualiza vari vel cReturnAux com o conte£do do RETURN-VALUE ---*/
  ASSIGN cReturnAux = RETURN-VALUE.
  

  /*--- Verifica ocorrˆncia de erros durante a grava‡Æo ---*/
  IF cReturnAux = "NOK":U THEN DO:
      /*--- Retorna temp-table RowErrors do DBO ---*/
      RUN getRowErrors IN hDBOItemAbastec (OUTPUT TABLE RowErrors).
      assign iErro = 0.
      /** Elimina todos os erros intrnos da BO (Navega»’o) **/
      for each  RowErrors
          where RowErrors.ErrorSubType = "INTERNAL":U exclusive-lock:
          delete RowErrors.
      end.
      /** Busca £ltimo erro criado na BO **/
      for last RowErrorsAux no-lock:
          assign iErro = RowErrorsAux.ErrorSequence.
      end.
      /** Percorre os erros da BO **/
      for each RowErrors no-lock:
          /** Cria erros na BO **/

          create RowErrorsAux.
          buffer-copy RowErrors except RowErrors.ErrorSequence  to RowErrorsAux
               /** Coloca sequ¼ncia **/
               assign RowErrorsAux.ErrorSequence = iErro + 1
                      RowErrorsAux.i-Linha       = ttRegistros.ilinha.
          assign iErro = RowErrorsAux.ErrorSequence.
      end.
  END.
  else do:
       IF NOT CAN-FIND(FIRST RowErrorsAux
                       WHERE RowErrorsAux.ErrorNumber = 0 NO-LOCK) THEN DO:
          IF tt-param.iLayout <> 4 THEN DO:
              /** Busca £ltimo erro criado na BO **/
              for last RowErrorsAux no-lock:
                  assign iErro = RowErrorsAux.ErrorSequence.
              end.
              {utp/ut-liter.i Registro_atualizado_sem_Erros. }
              create RowErrorsAux.
              assign RowErrorsAux.ErrorSequence     = iErro
                     RowErrorsAux.ErrorNumber       = 0
                     RowErrorsAux.i-Linha           = ttRegistros.ilinha
                     RowErrorsAux.ErrorDescription  = return-value
                     RowErrorsAux.ErrorSubType      = "":U.
          END.
       END.

       

  end.

    IF CAN-FIND(FIRST RowErrorsAux 
                WHERE (RowErrorsAux.ErrorSubType = "ERROR":U 
                OR     RowErrorsAux.ErrorSubType = "":U) 
                AND    RowErrorsAux.i-linha      = ttRegistros.ilinha
                AND    RowErrorsAux.ErrorNumber  > 0) THEN
        RETURN "NOK":U.

    RETURN "OK":U.


  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaItemLubrific) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaItemLubrific Procedure 
PROCEDURE piCriaItemLubrific :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Deve limpara a temp-table para evitar erros**/
empty temp-table ttItemLubrific.

 create ttItemLubrific.
 assign  ttItemLubrific.cd-tipo               = ttRegistros.cd-tipo 
         ttItemLubrific.cod-comptmento        = ttRegistros.cod-comptmento
         ttItemLubrific.cod-eqpto             = ttRegistros.cod-eqpto
         ttItemLubrific.cod-evento            = ttRegistros.cod-evento
         ttItemLubrific.cod-tip-mater         = ttRegistros.cod-mater
         ttItemLubrific.ep-codigo             = ttRegistros.ep-codigo 
         ttItemLubrific.it-codigo             = ttRegistros.it-codigo       
         ttItemLubrific.num-docto             = iDocto
         ttItemLubrific.val-dat-hora-invrtda  = ttRegistros.valDatHorInvert
         ttItemLubrific.val-mater-1           = ttRegistros.val-mater-1
         ttItemLubrific.val-mater-2           = ttRegistros.val-mater-2 
         ttItemLubrific.val-mater-3           = ttRegistros.val-mater-3 
         ttItemLubrific.val-quant             = ttRegistros.val-quant
         ttItemLubrific.cod-localiz           = ttRegistros.cod-localiz
         ttItemLubrific.cod-refer             = ttRegistros.cod-refer  
         ttItemLubrific.lote                  = ttRegistros.lote
         ttItemLubrific.cod-cta-ctbl          = ttRegistros.ct-codigo-lubrific
         ttItemLubrific.cod-ccusto            = ttRegistros.cc-codigo-lubrific.


   assign cReturnAux = "":U.
   /*--- Limpa temp-table RowErrors no DBO ---*/
   RUN emptyRowErrors IN hDBOItemLubrific.
   /*--- Transfere temp-table tt-requisicao para o DBO ---*/
   RUN setRecord IN hDBOItemLubrific (INPUT TABLE ttItemLubrific).
   /*--- Altera o registro corrente do DBO ---*/
   RUN createRecord IN hDBOItemLubrific.
   /*--- Atualiza vari vel cReturnAux com o conte£do do RETURN-VALUE ---*/
   ASSIGN cReturnAux = RETURN-VALUE.

   /*--- Verifica ocorrˆncia de erros durante a grava‡Æo ---*/
   IF cReturnAux = "NOK":U THEN DO:
         /*--- Retorna temp-table RowErrors do DBO ---*/
         RUN getRowErrors IN hDBOItemLubrific (OUTPUT TABLE RowErrors).
         assign iErro = 0.
        /** Elimina todos os erros intrnos da BO (Navega»’o) **/
         for each  RowErrors
             where RowErrors.ErrorSubType = "INTERNAL":U exclusive-lock:
             delete RowErrors.
         end.
         /** Busca £ltimo erro criado na BO **/
         for last RowErrorsAux no-lock:
             assign iErro = RowErrorsAux.ErrorSequence.
         end.
         /** Percorre os erros da BO **/
         for each RowErrors no-lock:
            /** Cria erros na BO **/

            create RowErrorsAux.
            buffer-copy RowErrors except RowErrors.ErrorSequence  to RowErrorsAux
                /** Coloca sequ¼ncia **/
                assign RowErrorsAux.ErrorSequence = iErro + 1
                       RowErrorsAux.i-Linha       = ttRegistros.ilinha.
            assign iErro = RowErrorsAux.ErrorSequence.
         end.
     end.
    else do:
         IF NOT CAN-FIND(FIRST RowErrorsAux
                         WHERE RowErrorsAux.ErrorNumber = 0 NO-LOCK) THEN DO:
            /** Busca £ltimo erro criado na BO **/
            for last RowErrorsAux no-lock:
                assign iErro = RowErrorsAux.ErrorSequence.
            end.
            {utp/ut-liter.i Registro_atualizado_sem_Erros. }

            create RowErrorsAux.
            assign RowErrorsAux.ErrorSequence     = iErro
                   RowErrorsAux.ErrorNumber       = 0
                   RowErrorsAux.i-Linha           = ttRegistros.ilinha
                   RowErrorsAux.ErrorDescription  = return-value
                   RowErrorsAux.ErrorSubType      = "":U.
         END.
    end.

    IF CAN-FIND(FIRST RowErrorsAux 
                WHERE (RowErrorsAux.ErrorSubType = "ERROR":U 
                OR     RowErrorsAux.ErrorSubType = "":U) 
                AND    RowErrorsAux.i-linha      = ttRegistros.ilinha
                AND    RowErrorsAux.ErrorNumber  > 0) THEN
        RETURN "NOK":U.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaPosto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaPosto Procedure 
PROCEDURE piCriaPosto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter desc-posto   as CHARACTER   no-undo.
DEFINE OUTPUT PARAMETER contPosto      AS CHAR     NO-UNDO.
DEFINE VARIABLE contPostoAux   AS INTEGER     NO-UNDO.
DEFINE VARIABLE parada AS LOGICAL     NO-UNDO.

EMPTY TEMP-TABLE ttposto.
    DO  contPostoAux = 1 TO 99999999:
        IF NOT CAN-FIND(FIRST mab-posto
                    WHERE INT(mab-posto.cod-posto) = contPostoAux) THEN DO:
            ASSIGN contPosto = STRING(contPostoAux,"99999999")
                   parada    = YES.
        END.
        IF parada = YES THEN
            LEAVE.
    END.

    FOR FIRST mab-posto NO-LOCK:
    CREATE ttposto.
    ASSIGN ttposto.cod-posto     =  contPosto
           ttposto.des-posto     =  desc-posto
           ttposto.cod-estabel   =  mab-posto.cod-estabel 
           ttposto.ep-codigo     =  mab-posto.ep-codigo   
           ttposto.cod-depos     =  mab-posto.cod-depos   
           ttposto.idi-posto     =  2  
           ttposto.cod-emitente  =  0.
    END.
        RUN goToKey IN hDBOPosto (INPUT ttposto.cod-posto).
        IF return-value = "NOK":U THEN DO:
            /*--- Limpa temp-table RowErrors no DBO ---*/
            RUN emptyRowErrors in hDBOPosto.
            /*--- Transfere temp-table tt-importa para o DBO ---*/
            RUN setRecord in hDBOPosto (INPUT TABLE ttPosto).
            /*--- Altera o registro corrente do DBO ---*/
            RUN createRecord in hDBOPosto.
        END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTempTables Procedure 
PROCEDURE piCriaTempTables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lExisteDocto                 AS LOGICAL    NO-UNDO.

/* /** Valida‡äes para alterar para nÆo integrado o documento **/ */
/* DEFINE BUFFER bf-mab-posto FOR mab-posto.                      */
/* DEFINE BUFFER bf-mab-tip-mater FOR mab-tip-mater.              */
/* DEFINE BUFFER bf-mab-tip-mater-item FOR mab-tip-mater-item.    */
/* DEFINE BUFFER bf-ITEM FOR ITEM.                                */

empty temp-table ttAbastecLubrific.
empty temp-table ttitemAbastec.
empty temp-table ttItemLubrific.

for each ttRegistros 
    where ttRegistros.dat-movto >= tt-param.dtInicial   
    and   ttRegistros.dat-movto <= tt-param.dtFinal 
    and   ttRegistros.cod-placa >= tt-param.placaIni
    and   ttRegistros.cod-placa <= tt-param.placaFim
    and   ttRegistros.ep-codigo >= tt-param.empIni      
    and   ttRegistros.ep-codigo <= tt-param.empFim      
    and   ttRegistros.cod-eqpto >= tt-param.eqptoIni    
    and   ttRegistros.cod-eqpto <= tt-param.eqptoFim exclusive-lock
    BY    ttRegistros.iLinha:
	
	/*** Inicio Projeto 118 - Seguran‡a por Estabelecimento ***/
    IF  l-seg-ativa-modulo THEN DO:
        FOR FIRST mab-eqpto FIELDS(cod-estabel)
            WHERE mab-eqpto.ep-codigo = ttRegistros.ep-codigo
            AND   mab-eqpto.cod-eqpto = ttRegistros.cod-eqpto NO-LOCK:
        END.

        IF NOT AVAIL mab-eqpto THEN DO:
			{utp/ut-liter.i Equipamento_Inexistente}
			CREATE RowErrorsAux.
			ASSIGN RowErrorsAux.ErrorSequence     = iErro + 1
				   RowErrorsAux.ErrorNumber       = 391
				   RowErrorsAux.i-Linha           = ttRegistros.ilinha
				   RowErrorsAux.ErrorDescription  = return-value
				   RowErrorsAux.ErrorSubType      = "":U.
			NEXT.
		END.
		
        RUN validaEstab IN THIS-PROCEDURE (INPUT mab-eqpto.cod-estabel,
                                           OUTPUT ttRegistros.log-erro-segur).

        /** Projeto 118 - Seguranca por Estabelecimento **/
        IF ttRegistros.log-erro-segur THEN DO:
            /** andre **/
            {utp/ut-liter.i Registro_nÆo_atualizado_devido_Segur._por_Estabelecimento.}
            CREATE RowErrorsAux.
            ASSIGN RowErrorsAux.ErrorSequence     = iErro + 1
                   RowErrorsAux.ErrorNumber       = 0
                   RowErrorsAux.i-Linha           = ttRegistros.ilinha
                   RowErrorsAux.ErrorDescription  = return-value
                   RowErrorsAux.ErrorSubType      = "":U.
            NEXT.
        END.
        
    END.
	/*** Final Projeto 118 - Seguran‡a por Estabelecimento ***/
	
    IF tt-param.iLayout = 3 AND l-usa-unid-negoc THEN DO:
        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF NOT(ttRegistros.cod-unid-negoc >= tt-param.unidNegocIni  AND
                   ttRegistros.cod-unid-negoc <= tt-param.unidNegocFim) THEN NEXT.
        &ENDIF
    END.

    {utp/ut-liter.i "Validando e Gerando Linha" * }
    RUN pi-Acompanhar IN h-acomp (return-value + ": " + string(ttRegistros.iLinha)).

    /** Registros AGrupados nÆo devem ser lidos **/
    if ttRegistros.l-agrupa = yes then next.

    /** Busca numera‡Æo do documento de Abastecimento/Lubrifica‡Æo**/
    run buscaDocumento in hDBOAbastecLubrific (output iDocto).

    ASSIGN lExisteDocto = NO.

    /** Usina Colombo - Conforme FO 1506.071 **/
    IF tt-param.iLayout = 3 THEN DO:
        FOR FIRST bf-mab-abastec-lubrific
            WHERE bf-mab-abastec-lubrific.ep-codigo            = ttRegistros.ep-codigo
            AND   bf-mab-abastec-lubrific.cod-eqpto            = ttRegistros.cod-eqpto
            AND   bf-mab-abastec-lubrific.cod-posto            = ttRegistros.cod-posto
            AND   bf-mab-abastec-lubrific.val-dat-hora-invrtda = ttRegistros.valDatHorInvert NO-LOCK:
            ASSIGN iDocto  = bf-mab-abastec-lubrific.num-docto
                   lExisteDocto = YES.
        END.
    END.
    /** Fim Altera‡Æo Usina Colombo **/

    blk-Registros:
    DO TRANSACTION:
        /** Usina Colombo - Conforme FO 1506.071 **/
        IF NOT(lExisteDocto) THEN DO:
           run piCriaAbastecLubrific in this-procedure.
        END.
        /** Fim Altera‡Æo Usina Colombo **/
        if return-value = "NOK":U  THEN undo blk-Registros, leave blk-Registros.
        
        /**** Verifica tipo de Layout**/
        
        if tt-param.iLayout = 1 or tt-param.iLayout = 3 then do: /** GoodCard ou PadrÆo **/
           if ttRegistros.Tipo = 1 then do: /** Abastecimento **/
               IF lExisteDocto THEN DO: 
                   RUN piAlteraParaNaoIntegrado IN THIS-PROCEDURE.
               END. /*lExisteDocto*/

               run piCriaItemAbastec in this-procedure.
               if return-value = "NOK":U then undo blk-Registros, leave blk-Registros.
           end.
           ELSE DO: /** Lubrifica‡Æo **/
               /** Se foi um documento criado de importa‡Æo, verifica se esse foi integrado                      **/
               /** Caso tenha sido e esse movimento que est  entrando agora integra com estoque                  **/
               /** altera o documento para nÆo integrado para realizar a integra‡Æo desse movimento no documento **/
               IF lExisteDocto THEN DO:
                   RUN piAlteraParaNaoIntegrado IN THIS-PROCEDURE.
               END.

              run piCriaItemLubrific in this-procedure.
              if return-value = "NOK":U then undo blk-Registros, leave blk-Registros.
           end.
        end.
        else do: /** CTF **/
            run piCriaItemAbastec in this-procedure.
                if return-value = "NOK":U then undo blk-Registros, leave blk-Registros.
        end.
    END.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicial Procedure 
PROCEDURE piInicial :
/*------------------------------------------------------------------------------
  Purpose:     piInicial
  Parameters:  <none>
  Notes:       Define os valores que serÆo mostrados o cabe‡alho e rodap‚
------------------------------------------------------------------------------*/
assign c-programa = "AB/0705"
       c-versao   = "2.00"
       c-revisao  = "000"
       /** Define o destino do arquivo a ser gerado **/
.
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 integer(tt-param.destino)}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-destino  = RETURN-VALUE.
&else
    ASSIGN c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}.
&endif

/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param exclusive-lock no-error.
    if avail tt-param then
       assign tt-param.eqptoini = "":U
              tt-param.eqptofim = "ZZZZZZZZZZZZZZZ":U.

/** Busca empresa padrÆo **/
for first param-global fields(grupo) no-lock:
    assign c-empresa = param-global.grupo.
end.

/** Guarda valores para imprimir t¡tulos **/
{utp/ut-liter.i "Importa‡Æo_Abastecimento/Lubrifica‡äes" *}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i "Abastecimento" *}
assign c-sistema = trim(return-value).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrecoItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrecoItem Procedure 
PROCEDURE piPrecoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pPosto  like mab-posto.cod-posto no-undo.
define input parameter pItem   like mab-tip-mater-item.it-codigo no-undo.
define input parameter pQuant  like mab-item-abastec.val-quant no-undo.
define buffer bfItem for item.
define buffer bfPosto for mab-posto.


/** Busca Estabelecimento **/
for first bfPosto fields(cod-depos idi-posto cod-estabel)
    where bfPosto.cod-posto = pPosto no-lock:
    assign cEstab = bfPosto.cod-estabel.
end.

if iTpValor <> 1 and 
   avail bfposto and 
   bfposto.idi-posto = 2 then return "NOK":U.

/** Busca Atributos do Item **/
for first bfItem fields(tipo-con-est loc-unica cod-localiz preco-ul-ent)
    where bfItem.it-codigo = pItem no-lock:
    assign iTpContEst  = bfItem.tipo-con-est
           dePreco     = bfItem.preco-ul-ent.
end.

/** Valor **/
case iTpValor:
    when 1 then do:
        /** Busca Pre‡o M‚dio **/
        for last mgf-cust-item-estoq
            where mgf-cust-item-estoq.it-codigo   = pItem
            and   mgf-cust-item-estoq.cod-estabel = cEstab no-lock:
            assign dePrecoMater  = mgf-cust-item-estoq.val-mater-1.
        end.
        /** Mostra Pre‡o Total **/
        assign deValor =   pQuant * dePrecoMater.
    end.


    /** Pre‡o M‚dio **/
    when 2 then do:
        /** Busca Pre‡o M‚dio **/
        for first item-estab 
            where item-estab.it-codigo   = pItem
            and   item-estab.cod-estabel = cEstab no-lock:
            assign dePrecoMater                                     = item-estab.val-unit-mat-m[1]
                                                                    + item-estab.val-unit-mob-m[1]
                                                                    + item-estab.val-unit-ggf-m[1].
        end.
        /** Mostra Pre‡o Total **/
        assign deValor =  pQuant * dePrecoMater.
    end.
    /** Pre‡o éltima Entrada **/
    when 3 then do:
        /** EMS 2.04B em diante **/
        &IF defined(bf_man_custeio_item) &THEN
            /** Busca Pre‡o Ultima Entrada **/
            for first item-uni-estab fields(preco-ul-ent)
                where item-uni-estab.it-codigo   = pItem
                and   item-uni-estab.cod-estabel = cEstab no-lock:
                assign dePrecoMater = item-uni-estab.preco-ul-ent.
            end.
        /** EMS 2.00 a EMS 2.04 **/
        &ELSE
            assign dePrecoMater = dePreco.
        &ENDIF
        /** Mostra Pre‡o Total **/
        assign deValor =  pQuant * dePrecoMater.
    end.
end case.
 

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrincipal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrincipal Procedure 
PROCEDURE piPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     piPrincipal
  Parameters:  <none>
  Notes:       Corpo princiapl da aplica‡Æo
------------------------------------------------------------------------------*/
/** Mostra frames de cabe‡alho e rodap‚ padräes da Datasul **/
view frame f-cabec.
view frame f-rodape. 

/** Inicializa programa de acompanhamento padrÆo Datasul **/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-titulo-relat).
DEFINE VARIABLE c-entry AS CHARACTER  format "x(100)" NO-UNDO.
DEFINE VARIABLE cDelimitador AS CHARACTER  NO-UNDO.
/******************************************************************
   Neste espa‡o deve-se colocar a l¢gica para busca as informa‡äes e 
   tamb‚m para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espa‡o.
******************************************************************/
empty temp-table ttAbastecLubrific. 
empty temp-table ttitemAbastec. 
empty temp-table ttItemLubrific.
empty temp-table ttRegistros. 
empty temp-table RowErrorsAux.


if tt-param.cDelimitador = ";" then
   assign cDelimitador   = ",".
else
   assign cDelimitador   = ";".

/** Guarda os campos que devem ser importados **/
FOR EACH tt-digita no-lock:
    IF c-lista-campos = "":U THEN 
        ASSIGN c-lista-campos = tt-digita.nom-campo.
    ELSE 
        ASSIGN c-lista-campos = c-lista-campos + cDelimitador + tt-digita.nom-campo.
END.
/** Guarda a temp-table numa vari vel handle  **/
assign h-ttRegistros = BUFFER ttRegistros:HANDLE
       iLinha = 1.

/** Define arquivo de entrada informado na p gina parƒmetros **/
input stream s-ab0705 from value(tt-param.arq-entrada).

/** Inicia leitura **/
repeat on stop undo, leave:
    import stream s-ab0705 unformatted c-linha.
    IF (c-linha = "" OR c-linha = ?) THEN NEXT.
    /** Cria registro das temp-tables **/
    h-ttRegistros:BUFFER-CREATE.
    /** importa pelo Layout PadrÆo**/
    if tt-param.iImport  = 1 then do:
        /** Percorre as colunas (campos) **/
        DO i-cont = 1 TO NUM-ENTRIES(c-lista-campos, cDelimitador):
            /** Busca o tipo de dado da coluna **/
            for first tt-digita 
                where tt-digita.nom-campo = ENTRY(i-cont,c-lista-campos,cDelimitador) no-lock:
                /** Guarda em handle o campo que deve ser lido **/
                ASSIGN h-field-ttRegistros = h-ttRegistros:BUFFER-FIELD(ENTRY(i-cont,c-lista-campos,cDelimitador)).
                /** Campo nÆo deve ser informado **/
                IF tt-digita.num-tam-campo = 0 THEN DO:
                    case tt-digita.cod-tip-dado:
                        when "integer":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = 0 NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "date":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = 12/31/9999 NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "decimal":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = decimal(0) NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "character":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = "" NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "logical":U then do:
                            ASSIGN i-logical = 0 NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                            if i-logical <= 0 then
                                assign h-field-ttRegistros:BUFFER-VALUE = no.
                            else 
                                assign h-field-ttRegistros:BUFFER-VALUE = yes.
                        END.
                    end case.
                END.
                /** Campo foi informado **/
                ELSE DO:
                    case tt-digita.cod-tip-dado:
                        when "integer":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = integer(SUBSTRING(c-linha,tt-digita.num-pos-inicial, tt-digita.num-tam-campo)) NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "date":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = date(SUBSTRING(c-linha,tt-digita.num-pos-inicial, tt-digita.num-tam-campo)) NO-ERROR.
                            IF error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "decimal":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = decimal(SUBSTRING(c-linha,tt-digita.num-pos-inicial, tt-digita.num-tam-campo)) NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "character":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = SUBSTRING(c-linha,tt-digita.num-pos-inicial, tt-digita.num-tam-campo) NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "logical":U then do:
                            ASSIGN i-logical = integer(SUBSTRING(c-linha,tt-digita.num-pos-inicial, tt-digita.num-tam-campo)) NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                            if i-logical <= 0 then
                                assign h-field-ttRegistros:BUFFER-VALUE = no.
                            else 
                                assign h-field-ttRegistros:BUFFER-VALUE = yes.
                        END.
                    end CASE.
                END.
            END.
        END. /** do **/
        assign ttRegistros.ilinha = iLinha
               iLinha             = iLinha + 1.
    END. /** tt-param.iImport  = 1 **/
    else do: /** Importa por Layout com delimitador **/
        /** Percorre as colunas (campos) **/
        DO i-cont = 1 TO NUM-ENTRIES(c-lista-campos, cDelimitador):
            /** Busca o tipo de dado da coluna **/
            for first tt-digita 
                where tt-digita.nom-campo = ENTRY(i-cont,c-lista-campos,cDelimitador) no-lock:
                /** Guarda em handle o campo que deve ser lido **/
                ASSIGN h-field-ttRegistros = h-ttRegistros:BUFFER-FIELD(ENTRY(i-cont,c-lista-campos,cDelimitador)).
                /** Campo nÆo deve ser informado **/
                IF tt-digita.num-tam-campo = 0 THEN DO:
                    case tt-digita.cod-tip-dado:
                        when "integer":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = 0 NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "date":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = ? NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "decimal":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = decimal(0) NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "character":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = "" NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "logical":U then do:
                            ASSIGN i-logical = 0 NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                            if i-logical <= 0 then
                                assign h-field-ttRegistros:BUFFER-VALUE = no.
                            else 
                                assign h-field-ttRegistros:BUFFER-VALUE = yes.
                        END.
                    end case.
                END.
                /** Campo foi informado **/
                else do:
                    assign c-entry = entry(tt-digita.num-pos-inicial,c-linha,tt-param.cDelimitador).
                    case tt-digita.cod-tip-dado:
                        when "integer":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = integer(c-entry) NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "date":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = date(c-entry) NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "decimal":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = decimal(c-entry) NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "character":U then do:
                            ASSIGN h-field-ttRegistros:BUFFER-VALUE = c-entry NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                        END.
                        when "logical":U then do:
                            ASSIGN i-logical = integer(c-entry) NO-ERROR.
                            if error-status:error then
                                run piCriaErroAux (29465, iLinha, tt-digita.nom-campo + '~~' + string(iLinha)).
                            if i-logical <= 0 then
                                assign h-field-ttRegistros:BUFFER-VALUE = no.
                            else 
                                assign h-field-ttRegistros:BUFFER-VALUE = yes.
                        END.
                    end case.
                END.
            END.
        END. /** do **/
        assign ttRegistros.ilinha = iLinha
               iLinha             = iLinha + 1.
    END. /** do else **/
END.

input stream s-ab0705 close.


run inicializaHandle in this-procedure. /**Inicializa as BOïs**/
/** Neste ponto busa as informa‡äes das tabelas oficiais para atualizar os registros da temp-table **/
run atualizaTTRegistros in this-procedure.
/**Agrupo abastecimentos/Lubrifica‡äes de Equipamentos com data e hora dentro da faixa de tempo parƒmetriza em tela **/
run piAgrupoAbastecimentos in this-procedure.
/** Ap¢s ler os registros cria as temp-tables e importa os registros para as BOïs em fun‡Æo do parƒmetros informados em tela **/
run piCriaTempTables in this-procedure. /** Cria temp-tables e envia informa‡äes para BOïs **/
run finalizaHandle in this-procedure. /** Elimina da men¢ria **/

/** Mostra dados importados e erros **/
run displayDados in this-procedure.


/******************************************************************
   Fim do espa‡o para l¢gica de c lculo e display das informa‡äes
******************************************************************/

/** Mostra parƒmetros selecionados **/
run displayParametros in this-procedure.
/** Finaliza programa de acompanhamento padrÆo Datasul **/
run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piTTRegistrosCopec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTTRegistrosCopec Procedure 
PROCEDURE piTTRegistrosCopec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE data-invertida AS DECIMAL FORMAT "999999999999"  NO-UNDO.
DEFINE VARIABLE hora           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE codigo-posto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cont           AS INTEGER     NO-UNDO.

/** Limpa as variaveis antes de iniciar a busca **/
assign iTpPosto          = 0
       dValDataHoraInver = 0.00
       cTpMater          = "":U
       cAtivid           = "":U
       cCTCodigo         = "":U
       cCCcodigo         = "":U
       deValor           = 0.00
       cont              = 0
       cCTCodigoLubrific = ""
       cCCcodigoLubrific = "".

IF  tt-param.arq-entrada <> "" THEN DO:
    EMPTY TEMP-TABLE ttRegistros.
    /*Testa se Arquivo txt foi encontrado*/
    IF SEARCH(tt-param.arq-entrada) <> ? THEN DO:
        /*importa arquivo txt */
        INPUT FROM value(tt-param.arq-entrada) CONVERT TARGET "ibm850" NO-ECHO.
        REPEAT:
            IMPORT DELIMITER ";" nombre patente vehiculo tarjeta fecha hora estacion guia unitario volumen monto odometro km-Lt km.
			
			FOR FIRST mab-eqpto
                WHERE mab-eqpto.cod-placa = patente
                OR    mab-eqpto.cod-eqpto = vehiculo NO-LOCK:
				
				CREATE ttRegistros.
				ASSIGN ttRegistros.cod-eqpto            = mab-eqpto.cod-eqpto
					   ttRegistros.cod-usuar            = c-seg-usuario
					   ttRegistros.cod-usuar-alter      = c-seg-usuario
					&IF DEFINED(bf_mnt_ems206b) &THEN
					   ttRegistros.cod-unid-negoc       = ""
					&ELSE
					   ttRegistros.cod_unid_negoc       = ""
					&ENDIF                           
					   ttRegistros.dat-movto            = fecha
					   ttRegistros.ep-codigo            = mab-eqpto.ep-codigo
					   ttRegistros.nr-nota-fis          = guia
					   ttRegistros.val-hodom-horim      = dec(replace(odometro,",",""))
					   ttRegistros.hra-inicial          = SUBSTRING(hora,1,2) + SUBSTRING(hora,4,2)
					   ttRegistros.cod-bomba            = ""
					   ttRegistros.dat-origin           = Fecha
					   ttRegistros.dsl-obs              = ""
					   ttRegistros.log-abastec-prim     = YES
					   ttRegistros.cod-placa            = patente
					   ttRegistros.ilinha               = cont + 1
					   cont                             = cont + 1.
					   
					   
                /*** Inicio Projeto 118 - Seguran‡a por Estabelecimento ***/
                IF  l-seg-ativa-modulo THEN DO:
                    RUN validaEstab IN THIS-PROCEDURE (INPUT mab-eqpto.cod-estabel,
                                                       OUTPUT ttRegistros.log-erro-segur).

                    /** Projeto 118 - Seguranca por Estabelecimento **/
                    if ttRegistros.log-erro-segur then do:
                        /** andre **/
                        {utp/ut-liter.i Registro_nÆo_atualizado_devido_Segur._por_Estabelecimento.}
                        create RowErrorsAux.
                        assign RowErrorsAux.ErrorSequence     = iErro
                               RowErrorsAux.ErrorNumber       = 0
                               RowErrorsAux.i-Linha           = ttRegistros.ilinha
                               RowErrorsAux.ErrorDescription  = return-value
                               RowErrorsAux.ErrorSubType      = "":U.
                        next.
                    end.
                END.

                FOR FIRST mab-histor-ativid
                    WHERE mab-histor-ativid.ep-codigo     = mab-eqpto.ep-codigo 
                    AND   mab-histor-ativid.cod-eqpto     = mab-eqpto.cod-eqpto NO-LOCK:
                    ASSIGN ttRegistros.cc-codigo          = mab-histor-ativid.cc-codigo  /* Utilizado ficha*/
                           ttRegistros.cod-ativid         = mab-histor-ativid.cod-ativid
                           ttRegistros.ct-codigo          = mab-histor-ativid.ct-codigo.  /* Utilizado na Ficha*/

                    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                        IF  mab-param.des-valor = "1":U THEN DO:
                            ASSIGN ttRegistros.ct-codigo-ficha-lubrific = mab-histor-ativid.cod-cta-ctbl-lubrific /* Utilizado na ficha*/
                                   ttRegistros.cc-codigo-ficha-lubrific = mab-histor-ativid.cod-ccusto-lubrific   /* Utilizado na ficha*/
                                   ttRegistros.ct-codigo-abastec        = mab-histor-ativid.ct-codigo
                                   ttRegistros.cc-codigo-abastec        = mab-histor-ativid.cc-codigo
                                   ttRegistros.ct-codigo-lubrific       = mab-histor-ativid.cod-cta-ctbl-lubrific
                                   ttRegistros.cc-codigo-lubrific       = mab-histor-ativid.cod-ccusto-lubrific.
                        END.
                    END.


                END.

                FOR FIRST mab-posto
                    WHERE mab-posto.des-posto = estacion NO-LOCK:
                       ASSIGN TTRegistros.cod-emitente    = mab-posto.cod-emitente
                               TTRegistros.cod-posto      = mab-posto.cod-posto. 
                END.
                
                IF NOT AVAIL mab-posto THEN DO:
                    RUN piCriaPosto (INPUT estacion,
                                     OUTPUT codigo-posto).
                                     
                    ASSIGN TTRegistros.cod-emitente   = 0
                           TTRegistros.cod-posto      = codigo-posto.
                END.

                FOR FIRST mab-motoris
                    WHERE mab-motoris.nom-motoris = nombre NO-LOCK:
                        ASSIGN ttRegistros.cod-estabel-matr = mab-motoris.cod-estabel
                               ttRegistros.cod-matr         = mab-motoris.cod-matr
                               ttRegistros.ep-codigo-matr   = mab-motoris.ep-codigo.
                END.
                
                IF nombre = "" OR nombre = "0" THEN DO:
                    FOR FIRST mab-param
                        WHERE cdn-param = 37 NO-LOCK:
                            ASSIGN ttRegistros.cod-estabel-matr = ENTRY(2,des-valor,",")
                                   ttRegistros.cod-matr         = ENTRY(3,des-valor,",").
                                   &IF "{&mguni_version}" >= "2.071" &THEN
                                       ttRegistros.ep-codigo-matr   = ENTRY(1,des-valor,",").
                                   &ELSE
                                       ttRegistros.ep-codigo-matr   = INT(ENTRY(1,des-valor,",")).
                                   &ENDIF
                    END.
                END.
                
                RUN buscaDocumento IN hDBOAbastecLubrific (OUTPUT ttRegistros.num-docto).
                ASSIGN hora = SUBSTRING(ttRegistros.hra-inicial,1,2) + SUBSTRING(ttRegistros.hra-inicial,4,2) + "00".

                
                run converteParaHoraInvertida (input string(ttRegistros.dat-movto,"99/99/9999"), 
                                               input hora,    
                                               output dValDataHoraInver).
                
                ASSIGN ttRegistros.valDatHorInvert = dValDataHoraInver
                       ttRegistros.val-mater-1     = (unitario * Volumen).

                run piConverteMoeda in this-procedure (input  ttRegistros.val-mater-1,
                                                       output ttRegistros.val-mater-2,
                                                       output ttRegistros.val-mater-3,
                                                       input  ttRegistros.dat-movto).
                
                ASSIGN ttRegistros.val-quant  = Volumen.

                for last mab-histor-combust
                    WHERE mab-histor-combust.ep-codigo   = mab-eqpto.ep-codigo
                    AND   mab-histor-combust.cod-eqpto  = mab-eqpto.cod-eqpto NO-LOCK:
                        ASSIGN ttRegistros.cod-mater = mab-histor-combust.cod-tip-mater.
                END.

                FOR LAST mab-tip-mater-item
                    WHERE mab-tip-mater-item.cod-tip-mater = ttRegistros.cod-mater NO-LOCK:
                    ASSIGN ttRegistros.it-codigo  =  mab-tip-mater-item.it-codigo. 
                END.
            END.
        END.
        INPUT CLOSE.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piTTRegistrosCTF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTTRegistrosCTF Procedure 
PROCEDURE piTTRegistrosCTF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cCGC like emitente.cgc  NO-UNDO.

/** Limpa as variaveis antes de iniciar a busca **/
assign iTpPosto          = 0
       dValDataHoraInver = 0.00
       cTpMater          = "":U
       cAtivid           = "":U
       cCTCodigo         = "":U
       cCCcodigo         = "":U
       deValor           = 0.00
       cDescComb         = "":U
       cCTCodigoLubrific = "":U
       cCCcodigoLubrific = "":U.

assign cCGC                  = trim(ttRegistros.cgc)
       ttRegistros.cod-posto = STRING(ttRegistros.icod-posto).

IF  cCGC = "0" THEN
    ASSIGN cCGC = "".

/** Busca emitente conforme CPNJ informado **/
for first emitente
    where emitente.cgc = cCGC AND cCGC <> "" no-lock:
end. 
if not avail emitente then do:
    /* Busca pelo c¢digo do posto */
    FOR FIRST mab-posto NO-LOCK
        WHERE mab-posto.cod-posto = ttRegistros.cod-posto:
        assign iTpPosto = mab-posto.idi-posto.
    END.
    IF NOT AVAIL mab-posto THEN DO:
        /* Busca pelo nome do posto */
        for first mab-posto
            where mab-posto.des-posto = trim(ttRegistros.des-posto) no-lock:
            assign ttRegistros.cod-posto = mab-posto.cod-posto
                   iTpPosto              = mab-posto.idi-posto.
        END.
        if not avail mab-posto then do:
            {utp/ut-liter.i "Posto"}
            run piCriaErroAux (56, ttRegistros.iLinha, return-value + '~~' + return-value).
        END.
    END.
END.
ELSE DO:
    for first mab-posto                                                  
        where mab-posto.cod-emitente  = emitente.cod-emitente no-lock:
        assign ttRegistros.cod-posto  = mab-posto.cod-posto
               iTpPosto               = mab-posto.idi-posto.
    END.
    if not avail mab-posto then do:
        /* Busca pelo c¢digo do posto */
        FOR FIRST mab-posto NO-LOCK
            WHERE mab-posto.cod-posto = ttRegistros.cod-posto:
            assign iTpPosto = mab-posto.idi-posto.
        END.
        IF NOT AVAIL mab-posto THEN DO:
            /* Busca pelo nome do posto */
            for first mab-posto
                where mab-posto.des-posto = trim(ttRegistros.des-posto) no-lock:
                assign ttRegistros.cod-posto = mab-posto.cod-posto
                       iTpPosto              = mab-posto.idi-posto.
            END.
            if not avail mab-posto then do:
                {utp/ut-liter.i "Posto"}
                run piCriaErroAux (56, ttRegistros.iLinha, return-value + '~~' + return-value).
            END.
        END.
    END.
END.

/** Serie gravado em branco e numero da nota fiscal grava o numero do abastecimento **/
assign ttRegistros.serie        = "":U
       ttRegistros.nr-nota-fis = string(ttRegistros.num-abastec). 

   /** Buca Informa‡äes do Equipamento busca pela placa **/
 for first mab-eqpto fields (ep-codigo  cod-eqpto cod-placa)
     where mab-eqpto.cod-placa = trim(ttRegistros.cod-placa) no-lock:
     assign ttRegistros.ep-codigo  = mab-eqpto.ep-codigo
            ttRegistros.cod-eqpto  = mab-eqpto.cod-eqpto.
 end.

assign ttRegistros.val-dat-hora-invrt = replace(ttRegistros.val-dat-hora-invrt,":","")
       ttRegistros.val-dat-hora-invrt = replace(ttRegistros.val-dat-hora-invrt,"/","").

/** Calcula valor do campo data hora invertida**/
assign ttRegistros.hra-inicial = trim(substring(ttRegistros.val-dat-hora-invrt,9,17))
       ttRegistros.dat-movto   = date(substring(ttRegistros.val-dat-hora-invrt,1,8)).

run converteParaHoraInvertida (input string(ttRegistros.dat-movto,"99/99/9999"), 
                               input ttRegistros.hra-inicial,
                               output dValDataHoraInver).

assign ttRegistros.valDatHorInvert = dValDataHoraInver.

/** atribui a descri‡Æo do tipo de material **/
case ttRegistros.cTpCombust:
    WHEN "A":U then assign cDescComb = "*DIESEL*":U.
    WHEN "H":U then assign cDescComb = "*DIESEL ADITIVADO*":U.
    WHEN "R":U then assign cDescComb = "*DIESEL S50*":U.
    WHEN "S":U then assign cDescComb = "*DIESEL S10*":U.
    WHEN "B":U then assign cDescComb = "*GASOLINA*":U.
    WHEN "D":U then assign cDescComb = "*GASOLINA ADITIVADA*":U.
    WHEN "F":U then assign cDescComb = "*GASOLINA PREMIUM*":U.
    WHEN "C":U then assign cDescComb = "*ALCOOL*":U.
    WHEN "E":U then assign cDescComb = "*ALCOOL ADITIVADO*":U.
    WHEN "G":U then assign cDescComb = "*GµS*":U.
end.

/** Importa‡Æo layout CTF sempre utilizar  o tipo de material conforme hist¢rico de combustivel do equipamento **/
for last mab-histor-combust                                         
  where mab-histor-combust.ep-codigo       =  ttRegistros.ep-codigo
    and   mab-histor-combust.cod-eqpto     =  ttRegistros.cod-eqpto 
    and   mab-histor-combust.idi-tip-consu > 1
    and   mab-histor-combust.dat-inicial   <= ttRegistros.dat-movto 
	and (mab-histor-combust.dat-desativ >= ttRegistros.dat-movto 
	     or mab-histor-combust.dat-desativ  = ?) no-lock:
    assign ttRegistros.cod-mater =  mab-histor-combust.cod-tip-mater 
           cTpMater              =  mab-histor-combust.cod-tip-mater.
end.

/* Caso nÆo econtre um tipo de material com consumo, busca um que tenha sem consumo */
IF  ttRegistros.cod-mater = "" THEN DO:
    FOR LAST mab-histor-combust
        WHERE mab-histor-combust.ep-codigo       = ttRegistros.ep-codigo
        AND   mab-histor-combust.cod-eqpto       = ttRegistros.cod-eqpto 
        AND   mab-histor-combust.idi-tip-consu   = 1
        AND   mab-histor-combust.dat-inicial    <= ttRegistros.dat-movto
        AND  (mab-histor-combust.dat-desativ    >= ttRegistros.dat-movto
              OR mab-histor-combust.dat-desativ = ?) no-lock:
        ASSIGN ttRegistros.cod-mater = mab-histor-combust.cod-tip-mater
               cTpMater              = mab-histor-combust.cod-tip-mater.
    END.
END.

/** quando o posto for interno tentar  primeiramente buscar item de controle total com a descri‡Æo do tipo de material **/
if cTpMater <> "":U then do:
    blk-item:
    for each mab-tip-mater-item fields (cod-tip-mater it-codigo )
        where mab-tip-mater-item.cod-tip-mater = cTpMater no-lock:
        if iTpPosto = 1 then do:  /** Posto interno **/           
           for first item 
               where item.it-codigo    = mab-tip-mater-item.it-codigo			    
                 AND ITEM.cod-obsoleto = 1
                 and item.tipo-contr   = 2 
                 and item.descricao-1 matches cDescComb no-lock:
               assign ttRegistros.it-codigo   = item.it-codigo.
               leave blk-item.
           end.
        end.
        else do: /** Posto externo **/
            for first item 
                where item.it-codigo    = mab-tip-mater-item.it-codigo 
                  and item.tipo-contr   = 4 
                  AND ITEM.cod-obsoleto = 1 no-lock:
                assign ttRegistros.it-codigo =  item.it-codigo.
                leave blk-item.
            end.
        end.
    end. /**do for each **/
end.

if iTpPosto = 1 then do:
    if ttRegistros.icod-bomba <> 0 then do:
        find first mab-bomba 
            where mab-bomba.cod-posto      = ttRegistros.cod-posto 
              and int(mab-bomba.cod-bomba) = ttRegistros.icod-bomba no-lock no-error.
        if avail mab-bomba then do:
            ttRegistros.cod-bomba = mab-bomba.cod-bomba.
        end.
    end.

    if ttRegistros.cod-bomba = "":U then do:
        for first mab-bomba
            where mab-bomba.cod-posto      = ttRegistros.cod-posto
            and   mab-bomba.cod-tip-mater  = cTpMater no-lock:
            assign ttRegistros.cod-bomba   = mab-bomba.cod-bomba.
        end.
    end.
end.

/** Busca Atividade e Conta Contÿbil do Hist½rico Atividade Equipamento **/    
run buscaAtividade in hDBOAbastecLubrific (input  ttRegistros.ep-codigo,
                                           input  ttRegistros.cod-eqpto,
                                           input  ttRegistros.dat-movto,
                                           output cAtivid,
                                           output cCTCodigo,
                                           output cCCcodigo,
                                           output ttRegistros.cod-unid-negoc,
                                           OUTPUT cCTCodigoLubrific,
                                           OUTPUT cCCcodigoLubrific,
                                           OUTPUT cHistEstab).

assign ttRegistros.cod-rota                 = cTrajeto
       ttRegistros.cod-ativid               = cAtivid
       ttRegistros.ct-codigo                = cCTCodigo
       ttRegistros.cc-codigo                = cCCcodigo.

FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
    IF  mab-param.des-valor = "1":U THEN DO:
        ASSIGN ttRegistros.ct-codigo-ficha-lubrific = cCTCodigoLubrific /* Utilizado na Ficha Abastecimento)*/
               ttRegistros.cc-codigo-ficha-lubrific = cCCcodigoLubrific  /* Utilizado na Ficha Abastecimento)*/
               ttRegistros.ct-codigo-abastec        = cCTCodigo
               ttRegistros.cc-codigo-abastec        = cCCCodigo
               ttRegistros.ct-codigo-lubrific       = cCTCodigoLubrific
               ttRegistros.cc-codigo-lubrific       = cCCcodigoLubrific.
    END.
END.


     /** Busca £ltimo erro criado **/
 /** Motorista em branco **/
For first mab-motoris
    Where mab-motoris.ep-codigo   = ttRegistros.ep-codigo-matr
      and mab-motoris.cod-estabel = ttRegistros.cod-estabel-matr
      AND mab-motoris.cod-matr    = ttRegistros.cod-matr no-lock:
End.

If not avail mab-motoris and tt-param.lValoresPadr then do:
    assign ttRegistros.ep-codigo-matr   =  iEmpMatr
           ttRegistros.cod-estabel-matr =  cEstabMatr
           ttRegistros.cod-matr         =  cMotorista.
    /** Busca éltimo erro criado **/
    for last RowErrorsAux no-lock:
        assign iErro = RowErrorsAux.ErrorSequence.
    end.
    {utp/ut-liter.i Motorista_atualizado_pelos_padräes * }

    create RowErrorsAux.
    assign RowErrorsAux.ErrorSequence     = iErro + 1
           RowErrorsAux.ErrorNumber       = 0
           RowErrorsAux.ErrorDescription  = return-value + " ":U + c-aux + " ":U + string(ttRegistros.iLinha).
end.
/** Busca usu rio do ems **/
assign  ttRegistros.cod-usuar = c-seg-usuario
        ttRegistros.val-mater-1 = ttRegistros.val-tot.
/** Busca valor do material se campo informado em branco **/

if ttRegistros.val-mater-1 = 0.00 then do:
    run piPrecoItem in this-procedure (input ttRegistros.cod-posto,
                                       input ttRegistros.it-codigo,
                                       input ttRegistros.val-quant).
    assign ttRegistros.val-mater-1 = deValor.
end.
/** Busca Valores para Moedas Alternativas **/
run piConverteMoeda in this-procedure (input  ttRegistros.val-mater-1,
                                       output ttRegistros.val-mater-2,
                                       output ttRegistros.val-mater-3,
                                       input  ttRegistros.dat-movto).

return "Ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piTTRegistrosGoodCard) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTTRegistrosGoodCard Procedure 
PROCEDURE piTTRegistrosGoodCard :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cData AS CHARACTER  NO-UNDO.
/** Limpa as variaveis antes de iniciar a busca **/
assign iTpPosto          = 0
       dValDataHoraInver = 0.00
       cTpMater          = "":U
       cAtivid           = "":U
       cCTCodigo         = "":U
       cCCcodigo         = "":U
       deValor           = 0.00
       cCTCodigoLubrific = "":U 
       cCCcodigoLubrific = "":U.

assign ttRegistros.hra-inicial = replace(ttRegistros.hra-inicial,":","")
       cData   = string(ttRegistros.dat-movto)
       cData   = replace(cData,"/","")
       ttRegistros.dat-movto = date(cData).

/** Busca data e hora invertida **/
run converteParaHoraInvertida (input string(ttRegistros.dat-movto,"99/99/9999"), 
                               input ttRegistros.hra-inicial,    
                               output dValDataHoraInver).
assign ttRegistros.valDatHorInvert = dValDataHoraInver.

   /** Buca Informa‡äes do Equipamento**/
/** Se nÆo encontra pela empresa/Equipamento busca pela placa **/
 for first mab-eqpto fields (ep-codigo  cod-eqpto cod-placa)
     where mab-eqpto.cod-placa = trim(ttRegistros.cod-placa) no-lock:
     assign ttRegistros.ep-codigo  = mab-eqpto.ep-codigo
            ttRegistros.cod-eqpto  = mab-eqpto.cod-eqpto.
 end.

/** Se matricula do Motorista nÆo informada busca pelo nome **/
 if ttRegistros.nom-motoris = "":U then do:
    if &IF "{&mguni_version}" >= "2.071" &THEN
           ttRegistros.ep-codigo-matr   = "" and
       &ELSE
           ttRegistros.ep-codigo-matr   = 0 and 
       &ENDIF
       ttRegistros.cod-estabel-matr = "":U AND
       ttRegistros.cod-matr         = "":U AND
       tt-param.lValoresPadr then do:
       assign ttRegistros.ep-codigo-matr   =  iEmpMatr
              ttRegistros.cod-estabel-matr =  cEstabMatr
              ttRegistros.cod-matr         =  cMotorista. /**Busca pelo motorita definido nos parƒmetros **/
               /** Busca £ltimo erro criado **/
      for last RowErrorsAux no-lock:
          assign iErro = RowErrorsAux.ErrorSequence.
      end.
      {utp/ut-liter.i Motorista_atualizado_pelos_padräes * }
      create RowErrorsAux.
      assign RowErrorsAux.ErrorSequence     = iErro + 1
             RowErrorsAux.ErrorNumber       = 0
             RowErrorsAux.ErrorDescription  = return-value 
             RowErrorsAux.i-Linha           = ttRegistros.ilinha.
    end.
    else
       for first mab-motoris
           where mab-motoris.nom-motoris = trim(ttRegistros.nom-motoris) no-lock:
           assign ttRegistros.ep-codigo-matr   = mab-motoris.ep-codigo
                  ttRegistros.cod-estabel-matr = mab-motoris.cod-estabel
                  ttRegistros.cod-matr         = mab-motoris.cod-matr.
        end.

 end.
 else  do:  
   for first mab-motoris
       where mab-motoris.nom-motoris = trim(ttRegistros.nom-motoris) no-lock:
       assign ttRegistros.ep-codigo-matr   = mab-motoris.ep-codigo   
              ttRegistros.cod-estabel-matr = mab-motoris.cod-estabel 
              ttRegistros.cod-matr         = mab-motoris.cod-matr.
    end.
    if not avail mab-motoris and tt-param.lValoresPadr then do:
       assign ttRegistros.ep-codigo-matr   =  iEmpMatr
              ttRegistros.cod-estabel-matr =  cEstabMatr
              ttRegistros.cod-matr         =  cMotorista. /**Busca pelo motorita definido nos parƒmetros **/
               /** Busca £ltimo erro criado **/
      for last RowErrorsAux no-lock:
          assign iErro = RowErrorsAux.ErrorSequence.
      end.
      {utp/ut-liter.i Motorista_atualizado_pelos_padräes * }
      create RowErrorsAux.
      assign RowErrorsAux.ErrorSequence     = iErro + 1
             RowErrorsAux.ErrorNumber       = 0
             RowErrorsAux.ErrorDescription  = return-value 
             RowErrorsAux.i-Linha           = ttRegistros.ilinha.
    end.
 end.
/** se emitente nÆo informado busca pelo cgc**/
assign c-cgc = replace(ttRegistros.cgc,".","")
       c-cgc = replace(c-cgc,"~/","")
       c-cgc = replace(c-cgc,"/","")
       c-cgc = replace(c-cgc,"~-","")
       c-cgc = replace(c-cgc,"-","")
       ttRegistros.cgc = trim(c-cgc).

/** se emitente nÆo informado busca pelo cgc**/
for first emitente
    where emitente.cgc = ttRegistros.cgc no-lock:
end.
if not avail emitente then do:
    IF  TRIM(ttRegistros.des-posto) = "" THEN DO:
        {utp/ut-liter.i "CNPJ/CPF" }
        RUN piCriaErroAux (56, ttRegistros.iLinha, RETURN-VALUE + ": " + ttRegistros.cgc).
    END.
    ELSE DO:
        /** se c¢digo do posto pela descri‡Æo**/
        for first mab-posto
            where mab-posto.des-posto     = trim(ttRegistros.des-posto) no-lock:
            assign ttRegistros.cod-posto  = mab-posto.cod-posto
                   iTpPosto               = mab-posto.idi-posto.
        end.
        if not avail mab-posto then do:
           {utp/ut-liter.i "Posto" }
           run piCriaErroAux (56, ttRegistros.iLinha, return-value).
           {utp/ut-liter.i "CNPJ/CPF" }
           RUN piCriaErroAux (56, ttRegistros.iLinha, RETURN-VALUE + ": " + ttRegistros.cgc).
        end.
    END.
end.
else do:
    for first mab-posto                                                  
        where mab-posto.cod-emitente  = emitente.cod-emitente no-lock:
        assign ttRegistros.cod-posto  = mab-posto.cod-posto
               iTpPosto               = mab-posto.idi-posto.
    end.
    if not avail mab-posto then do:
        /** se c¢digo do posto pela descri‡Æo**/
        for first mab-posto
            where mab-posto.des-posto     = trim(ttRegistros.des-posto) no-lock:
            assign ttRegistros.cod-posto  = mab-posto.cod-posto
                   iTpPosto               = mab-posto.idi-posto.
        end.
        if not avail mab-posto then do:
           {utp/ut-liter.i "Posto" }
           run piCriaErroAux (56, ttRegistros.iLinha, return-value).
        end.
    end. /** if not avail mab-posto **/
end. /** do else **/

assign cTpMater  = "":U.

/***********************************************
** Busca o Tipo de Material e o Item de Estoque 
** para o abastecimento ou lubrifica‡Æo 
***********************************************/
run buscaMaterial in this-procedure (1).   

/**Busca a bomba de combustivel**/
if iTpPosto = 1 then do: /**Posto intermo**/
    for first mab-bomba
        where mab-bomba.cod-posto     = trim(ttRegistros.cod-posto) 
        and   mab-bomba.cod-tip-mater = trim(ttRegistros.cod-mater) no-lock:
        assign ttRegistros.cod-bomba  = mab-bomba.cod-bomba.
    end.
end.
/** Busca Atividade e Conta Contÿbil do Hist½rico Atividade Equipamento **/    
run buscaAtividade in hDBOAbastecLubrific (input  ttRegistros.ep-codigo,
                                           input  ttRegistros.cod-eqpto,
                                           input  ttRegistros.dat-movto,
                                           output cAtivid,
                                           output cCTCodigo,
                                           output cCCcodigo,
                                           output ttRegistros.cod-unid-negoc,
                                           OUTPUT cCTCodigoLubrific,
                                           OUTPUT cCCcodigoLubrific,
                                           OUTPUT cHistEstab).

/** Atualiza tipo de Manuten‡Æo pelos Parƒmetros **/
if ttRegistros.Tipo = 2 and ttRegistros.cd-tipo = 0 and tt-param.lValoresPadr then do:
   assign ttRegistros.cd-tipo    =  iTpManut.
  /** Busca £ltimo erro criado **/
  for last RowErrorsAux no-lock:
      assign iErro = RowErrorsAux.ErrorSequence.
  end.
  {utp/ut-liter.i Tipo_manuten‡Æo_atualizado_pelos_padräes * }
  create RowErrorsAux.
  assign RowErrorsAux.ErrorSequence     = iErro + 1
         RowErrorsAux.ErrorNumber       = 0
         RowErrorsAux.ErrorDescription  = return-value 
         RowErrorsAux.i-Linha           = ttRegistros.ilinha.
end.
assign ttRegistros.cod-rota   =  cTrajeto.
 
/** Atividade do equipamento **/
assign ttRegistros.cod-ativid               = cAtivid
       ttRegistros.ct-codigo                = cCTCodigo
       ttRegistros.cc-codigo                = cCCCodigo.


FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
    IF  mab-param.des-valor = "1":U THEN DO:
        ASSIGN ttRegistros.ct-codigo-ficha-lubrific = cCTCodigoLubrific /* Utilizado na Ficha Abastecimento)*/
               ttRegistros.cc-codigo-ficha-lubrific = cCCcodigoLubrific  /* Utilizado na Ficha Abastecimento)*/
               ttRegistros.ct-codigo-abastec        = cCTCodigo
               ttRegistros.cc-codigo-abastec        = cCCCodigo
               ttRegistros.ct-codigo-lubrific       = cCTCodigoLubrific
               ttRegistros.cc-codigo-lubrific       = cCCcodigoLubrific.
    END.
END.



/** Busca usu rio do ems **/
assign  ttRegistros.cod-usuar = c-seg-usuario.
/** Serie sempre em branco **/
assign ttRegistros.serie  = "":U.
/** Busca valor do material se campo informado em branco **/
if ttRegistros.val-mater-1 = 0.00 then do:
    run piPrecoItem in this-procedure (input ttRegistros.cod-posto,
                                       input ttRegistros.it-codigo,
                                       input ttRegistros.val-quant).
  assign ttRegistros.val-mater-1 = deValor.
end.
/** Busca Valores para Moedas Alternativas **/
run piConverteMoeda in this-procedure (input  ttRegistros.val-mater-1,
                                       output ttRegistros.val-mater-2,
                                       output ttRegistros.val-mater-3,
                                       input  ttRegistros.dat-movto).
/** Para Layout da GoodCard o tipo de Evento ser  sempre troca **/
if ttRegistros.Tipo = 2 then do: 
   assign ttRegistros.cod-evento = cTroca .
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validaEstab) = 0 &THEN

PROCEDURE validaEstab:
    DEFINE INPUT  PARAMETER cCosEstab          LIKE mab-eqpto.cod-estabel  NO-UNDO.
    DEFINE OUTPUT PARAMETER l-erro-seg-estab   AS LOGICAL                 INITIAL NO NO-UNDO.

    /*** Inicio Projeto 118 - Seguran‡a por Estabelecimento ***/
    IF  NOT CAN-FIND(tt_estab_ems2 
               WHERE tt_estab_ems2.tta_cod_estab = cCosEstab) THEN DO:
        ASSIGN l-erro-seg-estab = YES.
    END.

END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piTTRegistrosOutros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTTRegistrosOutros Procedure 
PROCEDURE piTTRegistrosOutros :
/*------------------------------------------------------------------------------
  Purpose:     piTTRegistrosOutros
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cData               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-tipo-mat-invalido AS LOGICAL INITIAL NO NO-UNDO.

/** Limpa as variaveis antes de iniciar a busca **/
assign iTpPosto          = 0
       dValDataHoraInver = 0.00
       cTpMater          = "":U
       cAtivid           = "":U
       cCTCodigo         = "":U
       cCCcodigo         = "":U
       deValor           = 0.00
       cCTCodigoLubrific = "":U
       cCCcodigoLubrific = "":U
       dePrecoMater      = 0.00.


assign ttRegistros.hra-inicial = replace(ttRegistros.hra-inicial,":","")
       cData                   = string(ttRegistros.dat-movto)
       cData                   = replace(cData,"/","")
       ttRegistros.dat-movto   = date(cData).

/** Busca data e hora invertida **/
run converteParaHoraInvertida (input  string(ttRegistros.dat-movto,"99/99/9999"), 
                               input  ttRegistros.hra-inicial,    
                               output dValDataHoraInver).
assign ttRegistros.valDatHorInvert = dValDataHoraInver.

/** Buca Informa‡äes do Equipamento**/
if tt-param.iClassif =  2 then do:
&IF "{&mguni_version}" >= "2.071" &THEN
    if ttRegistros.ep-codigo = "" or ttRegistros.ep-codigo = ? then
&ELSE
    if ttRegistros.ep-codigo = 0 or ttRegistros.ep-codigo = ? then
&ENDIF
        assign ttRegistros.ep-codigo = tt-param.ep-prin.
    
    for first mab-eqpto fields (ep-codigo  cod-eqpto cc-codigo ct-codigo )
        where mab-eqpto.ep-codigo = ttRegistros.ep-codigo
        and   mab-eqpto.cod-eqpto = trim(ttRegistros.cod-eqpto) no-lock:
        for first mab-histor-ativid fields (ep-codigo  cod-eqpto cod-ativid dat-cadastro cc-codigo ct-codigo)
            where mab-histor-ativid.ep-codigo = mab-eqpto.ep-codigo
            and   mab-histor-ativid.cod-eqpto = mab-eqpto.cod-eqpto 
            and   mab-histor-ativid.dat-cadastro  <= ttRegistros.dat-movto  no-lock:
        END.
        assign ttRegistros.ep-codigo = mab-eqpto.ep-codigo 
               ttRegistros.cod-eqpto = mab-eqpto.cod-eqpto.
    END.
END.
else do: /** Se nÆo encontra pela empresa/Equipamento busca pela placa **/
    for first mab-eqpto fields (ep-codigo  cod-eqpto cod-placa)
        where mab-eqpto.cod-placa = trim(ttRegistros.cod-placa) no-lock:
        for first mab-histor-ativid fields (ep-codigo  cod-eqpto cod-ativid dat-cadastro cc-codigo ct-codigo)
            where mab-histor-ativid.ep-codigo      = mab-eqpto.ep-codigo
            and   mab-histor-ativid.cod-eqpto      = mab-eqpto.cod-eqpto 
            and    mab-histor-ativid.dat-cadastro <= ttRegistros.dat-movto  no-lock:
        END.
        assign ttRegistros.ep-codigo = mab-eqpto.ep-codigo
               ttRegistros.cod-eqpto = mab-eqpto.cod-eqpto.
    END.
END.

/** Atualiza tipo de Manuten‡Æo pelos Parƒmetros **/
if ttRegistros.Tipo = 2 and ttRegistros.cd-tipo = 0 and tt-param.lValoresPadr then do:
    assign ttRegistros.cd-tipo    =  iTpManut.
    /** Busca £ltimo erro criado **/
    for last RowErrorsAux no-lock:
        assign iErro = RowErrorsAux.ErrorSequence.
    END.
    {utp/ut-liter.i Tipo_manuten‡Æo_atualizado_pelos_padräes * }
    create RowErrorsAux.
    assign RowErrorsAux.ErrorSequence    = iErro + 1
           RowErrorsAux.ErrorNumber      = 0
           RowErrorsAux.ErrorDescription = return-value + " ":U + c-aux + " ":U + string(ttRegistros.iLinha).
END.


/** Se matricula do Motorista nÆo informada busca pelo nome **/
For first mab-motoris
    Where mab-motoris.ep-codigo   = ttRegistros.ep-codigo-matr
    and   mab-motoris.cod-estabel = ttRegistros.cod-estabel-matr
    AND   mab-motoris.cod-matr    = ttRegistros.cod-matr no-lock:
END.
If not avail mab-motoris then do:
    if ttRegistros.nom-motoris = "":U then do:
        if tt-param.lValoresPadr then do:
            ASSIGN ttRegistros.ep-codigo-matr   =  iEmpMatr
                   ttRegistros.cod-estabel-matr =  cEstabMatr
                   ttRegistros.cod-matr         =  cMotorista. /**Busca pelo motorita definido nos parƒmetros **/
            /** Busca éltimo erro criado **/
            for last RowErrorsAux no-lock:
                assign iErro = RowErrorsAux.ErrorSequence.
            END.
            {utp/ut-liter.i Motorista_atualizado_pelos_padräes * }
            create RowErrorsAux.
            assign RowErrorsAux.ErrorSequence     = iErro + 1
                   RowErrorsAux.ErrorNumber       = 0
                   RowErrorsAux.ErrorDescription  = return-value + "-":u + string(ttRegistros.iLinha).
        END.
    END.
    else do:
        for first mab-motoris
            where mab-motoris.nom-motoris = trim(ttRegistros.nom-motoris) no-lock:
            assign ttRegistros.ep-codigo-matr   = mab-motoris.ep-codigo  
                   ttRegistros.cod-estabel-matr = mab-motoris.cod-estabel
                   ttRegistros.cod-matr         = mab-motoris.cod-matr.
        END.
        if not avail mab-motoris and tt-param.lValoresPadr then do:
            assign ttRegistros.ep-codigo-matr   = iEmpMatr
                   ttRegistros.cod-estabel-matr = cEstabMatr
                   ttRegistros.cod-matr         = cMotorista. /**Busca pelo motorita definido nos parƒmetros **/
            /** Busca éltimo erro criado **/
            for last RowErrorsAux no-lock:
                assign iErro = RowErrorsAux.ErrorSequence.
            END.
            {utp/ut-liter.i Motorista_atualizado_pelos_padräes * }
            create RowErrorsAux.
            assign RowErrorsAux.ErrorSequence    = iErro + 1
                   RowErrorsAux.ErrorNumber      = 0
                   RowErrorsAux.ErrorDescription = return-value + "-":u + string(ttRegistros.iLinha).
        END.
    END.
END.
/** Se campo rota esta em branco busca o trajeto padrÆo definido nos parƒmetros**/
For first mab-trajeto
    Where mab-trajeto.cod-rota = ttRegistros.cod-rota no-lock:
END.
If not avail mab-trajeto and tt-param.lValoresPadr then do:
    assign ttRegistros.cod-rota = cTrajeto.
    /** Busca £ltimo erro criado **/
    for last RowErrorsAux no-lock:
        assign iErro = RowErrorsAux.ErrorSequence.
    END.
    {utp/ut-liter.i Trajeto_atualizado_pelos_padräes * }
    create RowErrorsAux.
    assign RowErrorsAux.ErrorSequence    = iErro + 1
           RowErrorsAux.ErrorNumber      = 0
           RowErrorsAux.ErrorDescription = return-value + " ":U + c-aux + " ":U + string(ttRegistros.iLinha).
END.

for first mab-posto
    where mab-posto.cod-posto = trim(ttRegistros.cod-posto) no-lock:
    assign iTpPosto = mab-posto.idi-posto.
END.
if ttRegistros.cod-posto = "":U or not avail mab-posto then do:
    for first mab-posto
        where mab-posto.cod-emitente = ttRegistros.cod-emitente no-lock:
        assign ttRegistros.cod-posto = mab-posto.cod-posto
               iTpPosto              = mab-posto.idi-posto.
    END.
    if ttRegistros.cod-emitente = 0 or not avail mab-posto then do:
        /** se emitente nÆo informado busca pelo cgc**/
        assign c-cgc = replace(ttRegistros.cgc,".","")
               c-cgc = replace(c-cgc,"~/","")
               c-cgc = replace(c-cgc,"/","")
               c-cgc = replace(c-cgc,"~-","")
               c-cgc = replace(c-cgc,"-","")
               ttRegistros.cgc = trim(c-cgc).
        for first emitente
            where emitente.cgc = trim(ttRegistros.cgc) no-lock:
            for first mab-posto                                                  
                where mab-posto.cod-emitente = emitente.cod-emitente no-lock:
                assign ttRegistros.cod-posto = mab-posto.cod-posto
                       iTpPosto              = mab-posto.idi-posto.
            END.
        END.
    END.
END.

/** Busca tipo de material pelo item **/
/** Busca tipo de material pelo item **/
if ttRegistros.it-codigo <> "":U then do:
    ASSIGN ttRegistros.cod-mater = ttRegistros.cod-tip-mater
           l-tipo-mat-invalido   = NO.
    IF  NOT CAN-FIND(FIRST mab-tip-mater
                     WHERE mab-tip-mater.cod-tip-mater = ttRegistros.cod-mater) THEN DO:
        IF  tt-param.lValoresPadr OR ttRegistros.cod-mater = "" THEN
            ASSIGN l-tipo-mat-invalido = YES.
        ELSE DO:
            {utp/ut-liter.i "Tipo_Material"}
            run piCriaErroAux (56, ttRegistros.iLinha, return-value + '~~' + return-value).
        END.
    END.
    IF  l-tipo-mat-invalido THEN DO:
        IF  ttRegistros.Tipo = 1 THEN DO:
            run buscaTipoMaterial in hDBOItemAbastec (input  ttRegistros.ep-codigo ,
                                                      input  ttRegistros.cod-eqpto,
                                                      input  ttRegistros.it-codigo,
                                                      input  ttRegistros.dat-movto,
                                                      output cTpMater,
                                                      output lLogAbastec,
                                                      output deTanque).
            assign ttRegistros.cod-mater = cTpMater.
            for last RowErrorsAux no-lock:
                assign iErro = RowErrorsAux.ErrorSequence.
            END.
            {utp/ut-liter.i Tipo_Material_atualizado_pelos_padräes * }
            create RowErrorsAux.
            assign RowErrorsAux.ErrorSequence    = iErro + 1
                   RowErrorsAux.ErrorNumber      = 0
                   RowErrorsAux.ErrorDescription = return-value + " ":U + c-aux + " ":U + string(ttRegistros.iLinha).
        END.
        ELSE DO:
            RUN buscaTipoMaterial IN hDBOItemLubrific (INPUT  ttRegistros.ep-codigo ,
                                                       INPUT  ttRegistros.cod-eqpto,
                                                       INPUT  ttRegistros.cod-comptmento,
                                                       INPUT  ttRegistros.it-codigo,
                                                       OUTPUT cTpMater,
                                                       OUTPUT deTanque).
            ASSIGN ttRegistros.cod-mater = cTpMater.
            FOR LAST RowErrorsAux NO-LOCK:
                ASSIGN iErro = RowErrorsAux.ErrorSequence.
            END.
            {utp/ut-liter.i Tipo_Material_atualizado_pelos_padräes * }
            CREATE RowErrorsAux.
            ASSIGN RowErrorsAux.ErrorSequence    = iErro + 1
                   RowErrorsAux.ErrorNumber      = 0
                   RowErrorsAux.ErrorDescription = RETURN-VALUE + " ":U + c-aux + " ":U + STRING(ttRegistros.iLinha).
        END.
    END.
END.
else do: /** Se item em branco **/
    /***********************************************
    ** Busca o Tipo de Material e o Item de Estoque 
    ** para o abastecimento ou lubrifica‡Æo 
    ***********************************************/
    run buscaMaterial in this-procedure (1).

    IF  ttRegistros.it-codigo = "" THEN DO:
        /** Busca o item do tipo de material **/
        for each mab-tip-mater-item fields (cod-tip-mater it-codigo)
            where mab-tip-mater-item.cod-tip-mater = trim(ttRegistros.cod-mater) no-lock:
            if iTpPosto = 1 then do:  /** Posto interno **/           
               if can-find (first item 
                            where item.it-codigo   = mab-tip-mater-item.it-codigo 
                            AND   ITEM.cod-obsoleto > 1 /* Situacao diferente de Ativo */
                            and   item.tipo-contr <> 4 no-lock) then do:
                    RUN piCriaErroAux (25983, ttRegistros.iLinha, mab-tip-mater-item.it-codigo).
               end.
            end.
        end. /**do for each **/
    END.

END. /** do else **/

/** Verifica se Posto ‚ interno **/
if iTpPosto = 1 then do:
    /** Busca c¢digo da bomba para o posto **/
    for first mab-bomba
        where mab-bomba.cod-posto = ttRegistros.cod-posto
        and   mab-bomba.cod-bomba = ttRegistros.cod-bomba no-lock:
    END.
    if not avail mab-bomba then do:
        if tt-param.lValoresPadr then do:
            for first mab-bomba
                where mab-bomba.cod-posto     = ttRegistros.cod-posto
                and   mab-bomba.cod-tip-mater = ttRegistros.cod-tip-mater no-lock:
                assign ttRegistros.cod-bomba = mab-bomba.cod-bomba.
                for last RowErrorsAux no-lock:
                    assign iErro = RowErrorsAux.ErrorSequence.
                END.
                {utp/ut-liter.i Bomba_atualizada_pelos_padräes * }
                create RowErrorsAux.
                assign RowErrorsAux.ErrorSequence    = iErro + 1
                       RowErrorsAux.ErrorNumber      = 0
                       RowErrorsAux.ErrorDescription = return-value + " ":U + c-aux + " ":U + string(ttRegistros.iLinha).
            END.
        END.
    END.
END.

/** Busca Atividade e Conta Contÿbil do Hist½rico Atividade Equipamento **/
run buscaAtividade in hDBOAbastecLubrific (input  ttRegistros.ep-codigo,
                                           input  ttRegistros.cod-eqpto,
                                           input  ttRegistros.dat-movto,
                                           output cAtivid,
                                           output cCTCodigo,
                                           output cCCcodigo,
                                           output cCodUnidNegoc,
                                           OUTPUT cCTCodigoLubrific,
                                           OUTPUT cCCcodigoLubrific,
                                           OUTPUT cHistEstab).

/** Atividade nÆo informada**/
IF NOT CAN-FIND(FIRST mab-ativid 
                WHERE mab-ativid.cod-ativid = ttRegistros.cod-ativid) THEN
    ASSIGN ttRegistros.cod-ativid = cAtivid.


FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
    IF mab-param.des-valor = "1":U THEN DO:

        /*  È validado os campos "ttRegistros.ct-codigo" e "ttRegistros.cc-codigo", sendo que s’o campos existentes no layout, se estiver em branco "" estaremos gravando
        informa»„es vindas da mab-histor-ativid (conforme chamado acima "buscaAtividade"),
        caso contrario informa»’o contidas no layout ser’o gravadas nos campos "ttRegistros.ct-codigo-lubrific" e "ttRegistros.cc-codigo-lubrific" */
        IF ttRegistros.ct-codigo = "" AND ttRegistros.cc-codigo = "" THEN DO:
            /* esse bloco alimenta os registros de conta e centro de custo com base no historico de estabelecimento do equipamento. Essas informa‡äes vem da buscaAtividade executa anteriormente */ 

            /* ttRegistros.Tipo = 2 ² Lubrificacao */
            IF ttRegistros.Tipo = 2 THEN DO:
                /* Contas Lubrificacao sugeridas para Lubrificacao */
                ASSIGN ttRegistros.ct-codigo-lubrific = cCTCodigoLubrific
                       ttRegistros.cc-codigo-lubrific = cCCcodigoLubrific.
            END.
            ELSE DO:
                /* Contas PadÆo sugeridas para Abastecimento */
                ASSIGN ttRegistros.ct-codigo-abastec = cCTCodigo
                       ttRegistros.cc-codigo-abastec = cCCcodigo.
            END.
        END.
        ELSE DO:
            /* ttRegistros.Tipo = 2 ² Lubrificacao */
            IF ttRegistros.Tipo = 2 THEN DO:
                /* Informa‡äes contidas no layout serÆo gravadas nos campos "ttRegistros.ct-codigo-lubrific" e "ttRegistros.cc-codigo-lubrific" */
                ASSIGN ttRegistros.ct-codigo-lubrific = ttRegistros.ct-codigo
                       ttRegistros.cc-codigo-lubrific = ttRegistros.cc-codigo.
            END.
            ELSE DO:
                /* Informa‡äes contidas no layout serÆo gravadas nos campos "ttRegistros.ct-codigo-abastec" e "ttRegistros.cc-codigo-abastec" */
                ASSIGN ttRegistros.ct-codigo-abastec = ttRegistros.ct-codigo
                       ttRegistros.cc-codigo-abastec = ttRegistros.cc-codigo.
            END.
        END.

        /* Os campos "ttRegistros.ct-codigo", "ttRegistros.cc-codigo", "ttRegistros.ct-codigo-ficha-lubrific" e "ttRegistros.cc-codigo-ficha-lubrific" sempre ser’o
        alimentados/carregados com base no historico estabelecimento vindo da chamada buscaAtividade */
        ASSIGN ttRegistros.ct-codigo          = cCTCodigo
               ttRegistros.cc-codigo          = cCCcodigo
               ttRegistros.ct-codigo-ficha-lubrific = cCTCodigoLubrific
               ttRegistros.cc-codigo-ficha-lubrific = cCCcodigoLubrific.
    END.
    ELSE DO:
        /* CHAMADO: TETKUR                                                                                    */
        IF  ttRegistros.ct-codigo = "" THEN
            ASSIGN ttRegistros.ct-codigo          = cCTCodigo.
        IF  ttRegistros.cc-codigo = "" THEN
            ASSIGN ttRegistros.cc-codigo          = cCCcodigo.
    END.
END.

&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc AND ttRegistros.cod-unid-negoc = "":U THEN
        ASSIGN ttRegistros.cod-unid-negoc = cCodUnidNegoc.
&ELSE
    ASSIGN ttRegistros.cod_unid_negoc = cCodUnidNegoc.
&ENDIF

/** Se campo rota esta em branco busca o trajeto padrÆo definido nos parƒmetros**/
For first mab-ativid
    Where mab-ativid.cod-ativid = ttRegistros.cod-ativid no-lock:
END.

/** Atividade nÆo informada**/
if not avail mab-ativid and tt-param.lValoresPadr then do:
    assign ttRegistros.cod-ativid = cAtivid.
    /** Busca £ltimo erro criado **/
    for last RowErrorsAux no-lock:
        assign iErro = RowErrorsAux.ErrorSequence.
    END.
    {utp/ut-liter.i Atividade_atualizado_pelos_padräes * }
    create RowErrorsAux.
    assign RowErrorsAux.ErrorSequence    = iErro + 1
           RowErrorsAux.ErrorNumber      = 0
           RowErrorsAux.ErrorDescription = return-value  + " ":U + c-aux + " ":U + string(ttRegistros.iLinha).
END.

IF NOT CAN-FIND(FIRST tt_cta_integr)
THEN DO:
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    EMPTY TEMP-TABLE tt_log_erro.
    
    RUN pi_busca_ctas_integr IN h_api_cta_ctbl (INPUT "",
                                                INPUT "CEP",
                                                INPUT "",
                                                INPUT "(nenhum)",
                                                INPUT TODAY,
                                                OUTPUT TABLE tt_cta_integr,
                                                OUTPUT TABLE tt_log_erro).
    
    DELETE OBJECT h_api_cta_ctbl.
END.

FOR FIRST tt_cta_integr          
    WHERE tt_cta_integr.ttv_cod_cta_ctbl = ttRegistros.ct-codigo NO-LOCK:
END.


IF  CAN-FIND (FIRST tt_log_erro NO-LOCK) THEN DO:
    ASSIGN iErro = 0
           c-erro-financeiro = "".
    FOR EACH tt_log_erro EXCLUSIVE-LOCK:
        {utp/ut-liter.i C¢digo_Erro_Financeiro}
        ASSIGN c-erro-financeiro = RETURN-VALUE + ": " + STRING(tt_log_erro.ttv_num_cod_erro).

        CREATE RowErrorsAux.
        ASSIGN RowErrorsAux.ErrorSequence = iErro
               RowErrorsAux.ErrorNumber  = 52046.
        
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 52046,
                           INPUT tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda + "~~" + c-erro-financeiro).
        ASSIGN RowErrorsAux.ErrorDescription  = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT 52046,
                           INPUT tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda + "~~" + c-erro-financeiro).

        ASSIGN RowErrorsAux.ErrorHelp = RETURN-VALUE
               RowErrorsAux.ErrorType = "EMS":U
               RowErrorsAux.ErrorSubType = "ERROR":U
               iErro = iErro + 1.
    END.
END.

/** Conta Contabil nÆo informada**/
IF NOT AVAIL tt_cta_integr AND tt-param.lValoresPadr THEN DO:
    ASSIGN ttRegistros.ct-codigo = cCTCodigo.
    /** Busca £ltimo erro criado **/
    FOR LAST RowErrorsAux NO-LOCK:
        ASSIGN iErro = RowErrorsAux.ErrorSequence.
    END.
    {utp/ut-liter.i Conta_atualizado_pelos_padräes * }
    CREATE RowErrorsAux.
    ASSIGN RowErrorsAux.ErrorSequence     = iErro + 1
           RowErrorsAux.ErrorNumber       = 0
           RowErrorsAux.ErrorDescription  = RETURN-VALUE  + " ":U + c-aux + " ":U + STRING(ttRegistros.iLinha).
END.

FOR FIRST centro-custo
    WHERE centro-custo.cc-codigo = ttRegistros.cc-codigo NO-LOCK:
END.

/** Centro de Custo nÆo informado **/
if not avail centro-custo and tt-param.lValoresPadr then do:
    assign ttRegistros.cc-codigo = cCCcodigo.
    /** Busca £ltimo erro criado **/
    for last RowErrorsAux no-lock:
        assign iErro = RowErrorsAux.ErrorSequence.
    END.
    {utp/ut-liter.i Centro_Custo_atualizado_pelos_padräes * }
    create RowErrorsAux.
    assign RowErrorsAux.ErrorSequence     = iErro + 1
           RowErrorsAux.ErrorNumber       = 0
           RowErrorsAux.ErrorDescription  = return-value + " ":U + c-aux + " ":U + string(ttRegistros.iLinha).
END.
/** Busca usu rio do ems **/
assign ttRegistros.cod-usuar = c-seg-usuario.
/** Busca valor do material se campo informado em branco **/
if ttRegistros.val-mater-1 = 0.00 then do:

    run piPrecoItem in this-procedure (input ttRegistros.cod-posto,
                                       input ttRegistros.it-codigo,
                                       input ttRegistros.val-quant).
    assign ttRegistros.val-mater-1 = deValor.
END.
/** Busca Valores para Moedas Alternativas **/
run piConverteMoeda in this-procedure (input  ttRegistros.val-mater-1,
                                       output ttRegistros.val-mater-2,
                                       output ttRegistros.val-mater-3,
                                       input  ttRegistros.dat-movto).
/** Busca tipo de Evento quando Layout for o padrÆo quando for lubirifica‡Æo**/
if ttRegistros.Tipo = 2 then do:
    /** Evento em branco busca evento definido nos padräes do m¢dulo**/
    if ttRegistros.cod-evento = "":U and tt-param.lValoresPadr then do:
        /** Verifica tipo de troca**/
        case ttRegistros.tip-troca :
            when 1 then
                assign ttRegistros.cod-evento = cTroca . /*Troca de Ol‚o*/
            when 2 then
                assign ttRegistros.cod-evento = cRemonta . /** Remonta de Ol‚o**/
            when 3 then
                assign ttRegistros.cod-evento = cAnalise. /** An lise de Ol‚o**/
        end case.
        /** Busca £ltimo erro criado **/
        for last RowErrorsAux no-lock:
            assign iErro = RowErrorsAux.ErrorSequence.
        END.
        {utp/ut-liter.i Evento_atualizado_pelos_padräes * }
        create RowErrorsAux.
        assign RowErrorsAux.ErrorSequence    = iErro + 1
               RowErrorsAux.ErrorNumber      = 0
               RowErrorsAux.ErrorDescription = return-value + " ":U + c-aux + " ":U + string(ttRegistros.iLinha).
    END.
END.

/****************** Inicio da validacao de conta Lubrificacao e centro de custo Lubrificacao **************************/
FOR FIRST tt_cta_integr          
    WHERE tt_cta_integr.ttv_cod_cta_ctbl = ttRegistros.ct-codigo-lubrific NO-LOCK:
END.

IF  CAN-FIND (FIRST tt_log_erro NO-LOCK) THEN DO:
    ASSIGN iErro = 0
           c-erro-financeiro = "".
    FOR EACH tt_log_erro EXCLUSIVE-LOCK:
        {utp/ut-liter.i C½digo_Erro_Financeiro}
        ASSIGN c-erro-financeiro = RETURN-VALUE + ": " + STRING(tt_log_erro.ttv_num_cod_erro).

        CREATE RowErrorsAux.
        ASSIGN RowErrorsAux.ErrorSequence = iErro
               RowErrorsAux.ErrorNumber  = 52046.
        
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 52046,
                           INPUT tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda + "~~" + c-erro-financeiro).
        ASSIGN RowErrorsAux.ErrorDescription  = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT 52046,
                           INPUT tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda + "~~" + c-erro-financeiro).

        ASSIGN RowErrorsAux.ErrorHelp = RETURN-VALUE
               RowErrorsAux.ErrorType = "EMS":U
               RowErrorsAux.ErrorSubType = "ERROR":U
               iErro = iErro + 1.
    END.
END.

/** Conta Lubrificacao n’o informada**/
IF NOT AVAIL tt_cta_integr AND tt-param.lValoresPadr THEN DO:
    ASSIGN ttRegistros.ct-codigo-lubrific = cCTCodigoLubrific.

    /** Busca œltimo erro criado **/
    FOR LAST RowErrorsAux NO-LOCK:
        ASSIGN iErro = RowErrorsAux.ErrorSequence.
    END.
    {utp/ut-liter.i Conta_Lubrifica»’o_atualizado_pelos_padr„es * }
    CREATE RowErrorsAux.
    ASSIGN RowErrorsAux.ErrorSequence     = iErro + 1
           RowErrorsAux.ErrorNumber       = 0
           RowErrorsAux.ErrorDescription  = RETURN-VALUE  + " ":U + c-aux + " ":U + STRING(ttRegistros.iLinha).
END.

FOR FIRST centro-custo
    WHERE centro-custo.cc-codigo = ttRegistros.cc-codigo-lubrific NO-LOCK:
END.

/** Centro de Custo Lubrificacaon’o informado **/
if not avail centro-custo and tt-param.lValoresPadr then do:
    assign ttRegistros.cc-codigo-lubrific = cCCcodigoLubrific.

    /** Busca œltimo erro criado **/
    for last RowErrorsAux no-lock:
        assign iErro = RowErrorsAux.ErrorSequence.
    END.
    {utp/ut-liter.i Centro_Custo_Lubrifica»’o_atualizado_pelos_padr„es * }
    create RowErrorsAux.
    assign RowErrorsAux.ErrorSequence     = iErro + 1
           RowErrorsAux.ErrorNumber       = 0
           RowErrorsAux.ErrorDescription  = return-value + " ":U + c-aux + " ":U + string(ttRegistros.iLinha).
END.

/****************** Final da validacao de conta Lubrificacao e centro de custo Lubrificacao **************************/

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

