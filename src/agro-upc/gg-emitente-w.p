/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-EMITENTE-W 2.00.00.015 } /*** "010015" ***/



 /***********************************************************************
**  Programa...: agro-upc/gg-emitente-w.p
**  Descricao..: Upc utilizada na exclus∆o da tabela gg-ext-emitente
**  data.......: Agosto/2003
************************************************************************/
DEFINE PARAM BUFFER b-emitente     FOR mgadm.emitente.
DEFINE PARAM BUFFER b-old-emitente FOR mgadm.emitente.

DEFINE VARIABLE c-mes1              AS CHARACTER FORMAT "x(31)" NO-UNDO.
DEFINE VARIABLE c-mes2              AS CHARACTER FORMAT "x(7)"  NO-UNDO.
DEFINE VARIABLE i-cod-inscr-padrao  AS INTEGER                  NO-UNDO.
DEFINE VARIABLE i-cod-inscricao     AS INTEGER                  NO-UNDO.


FIND FIRST gg-param NO-LOCK NO-ERROR.

IF  AVAIL gg-param THEN DO:

    {utp/ut-liter.i "Alter Conta Preferencial DE: " * R}
    ASSIGN c-mes1 = RETURN-VALUE.
    {utp/ut-liter.i " Para: " * R}
    ASSIGN c-mes2 = RETURN-VALUE.
    
    FIND FIRST gg-ext-emitente EXCLUSIVE-LOCK
         WHERE gg-ext-emitente.cod-emitente   = b-emitente.cod-emitente NO-ERROR.
    IF NOT AVAIL gg-ext-emitente THEN DO: 
       CREATE gg-ext-emitente.
       ASSIGN gg-ext-emitente.cod-emitente = b-emitente.cod-emitente.
    END.
        
    FIND FIRST fat-ext-emitente EXCLUSIVE-LOCK
         WHERE fat-ext-emitente.cod-emitente   = b-emitente.cod-emitente NO-ERROR.
    IF NOT AVAIL fat-ext-emitente THEN DO: 
       CREATE fat-ext-emitente.
       ASSIGN fat-ext-emitente.cod-emitente = b-emitente.cod-emitente.
    END.
    
    
    /*****************************CRIAÄ«O AUTOMµTICA DE INSCRIÄ«O ***************/
    /*para o delete usar o  gg-inscricao-padrao.cod-propriet   e o num-livre-4 para delete da gg-inscricao-padrao */
    IF  (b-emitente.identific > 1 AND substr(gg-param.char-2,68,1) = "S":U) /*Fornecedor*/ OR
        (b-emitente.identific <> 2 AND substr(gg-param.char-2,69,1) = "S":U) /*Cliente*/ THEN DO:
    
            ASSIGN i-cod-inscr-padrao = 0 
                   i-cod-inscricao    = 0. 
          
            IF  gg-ext-emitente.num-livre-3 <> 0 THEN
                RUN pi-inscr-padrao (INPUT  gg-ext-emitente.num-livre-3,
                                     OUTPUT i-cod-inscr-padrao). 
            ELSE DO: 
                IF  NOT CAN-FIND(FIRST gg-inscricao NO-LOCK 
                                 WHERE gg-inscricao.cod-emitente = b-emitente.cod-emitente) THEN DO: 
                    /* n∆o tem nenhuma inscriá∆o, ent∆o deve criar autom†tico */
                    /* criar um novo */
                    RUN pi-inscr-padrao (INPUT  0,
                                         OUTPUT i-cod-inscr-padrao). 
           
                END.
            END.
                    
            IF  i-cod-inscr-padrao <> 0 THEN DO: 
                
                IF  gg-ext-emitente.num-livre-4 <> 0 THEN
                    RUN pi-inscricao    (INPUT  i-cod-inscr-padrao, 
                                         INPUT  gg-ext-emitente.num-livre-4,
                                         OUTPUT i-cod-inscricao).  
                ELSE 
                    RUN pi-inscricao    (INPUT  i-cod-inscr-padrao, 
                                         INPUT  0,
                                         OUTPUT i-cod-inscricao).  
            END.
            
            ASSIGN gg-ext-emitente.num-livre-3  = IF i-cod-inscr-padrao > 0 THEN i-cod-inscr-padrao ELSE gg-ext-emitente.num-livre-3
                   gg-ext-emitente.num-livre-4  = IF i-cod-inscricao    > 0 THEN i-cod-inscricao    ELSE gg-ext-emitente.num-livre-4.
              

    END.
END.

RETURN "OK":U.


/* ********** PROCEDURES ********** */

PROCEDURE pi-inscricao: 
    DEF INPUT  PARAM p-cod-inscr-padrao        LIKE gg-inscricao-padrao.cod-inscricao NO-UNDO. 
    DEF INPUT  PARAM p-cod-inscricao           LIKE gg-inscricao.cod-inscricao NO-UNDO. 
    DEF OUTPUT PARAM p-cod-inscricao-novo      LIKE gg-inscricao.cod-inscricao NO-UNDO. 

    IF  p-cod-inscricao <> 0 THEN DO:
        FIND FIRST gg-inscricao EXCLUSIVE-LOCK 
             WHERE gg-inscricao.cod-emitente  = b-emitente.cod-emitente 
               AND gg-inscricao.cod-inscricao = p-cod-inscricao NO-ERROR. 
        IF AVAIL gg-inscricao THEN
           ASSIGN p-cod-inscricao-novo = p-cod-inscricao.
        ELSE IF NOT CAN-FIND(FIRST gg-inscricao NO-LOCK 
                             WHERE gg-inscricao.cod-emitente = b-emitente.cod-emitente) THEN DO: /*foi deletado e n∆o existe nada*/

            RUN pi-busca-ultima-inscricao (OUTPUT p-cod-inscricao-novo). 
    
            CREATE gg-inscricao.
            ASSIGN gg-inscricao.cod-emitente  = b-emitente.cod-emitente 
                   gg-inscricao.cod-inscricao = p-cod-inscricao-novo. 
        END.
    END.
    ELSE DO:  
        RUN pi-busca-ultima-inscricao (OUTPUT p-cod-inscricao-novo). 

        CREATE gg-inscricao.
        ASSIGN gg-inscricao.cod-emitente  = b-emitente.cod-emitente 
               gg-inscricao.cod-inscricao = p-cod-inscricao-novo. 
    END.

    IF p-cod-inscricao-novo > 0 THEN DO: 
       ASSIGN gg-inscricao.ins-estadual                     = b-emitente.ins-estadual
              gg-inscricao.nom-inscricao                    = b-emitente.nome-emit
              gg-inscricao.endereco                         = b-emitente.endereco
              gg-inscricao.bairro                           = b-emitente.bairro
              gg-inscricao.cidade                           = b-emitente.cidade
              gg-inscricao.estado                           = b-emitente.estado
              gg-inscricao.cep                              = b-emitente.cep
              gg-inscricao.pais                             = b-emitente.pais
              gg-inscricao.telefone[1]                      = b-emitente.telefone[1]
              gg-inscricao.telefone[2]                      = b-emitente.telefone[2]
              gg-inscricao.ramal[1]                         = b-emitente.ramal[1]
              gg-inscricao.ramal[2]                         = b-emitente.ramal[2]
              gg-inscricao.ins-municipal                    = b-emitente.ins-municipal
              gg-inscricao.e-mail                           = b-emitente.e-mail
              gg-inscricao.complemento                      = b-emitente.endereco2
              gg-inscricao.nom-contato                      = b-emitente.nome-emit
              gg-inscricao.cgc                              = b-emitente.cgc
              gg-inscricao.int-1                            = p-cod-inscr-padrao 
              gg-inscricao.ativo                            = YES.

       RELEASE gg-inscricao.
    END.

   
    RETURN "OK":U.
end procedure.                 



PROCEDURE pi-inscr-padrao: 
    DEF INPUT  PARAM p-cod-inscr-padrao        LIKE gg-inscricao-padrao.cod-inscricao NO-UNDO. 
    DEF OUTPUT PARAM p-cod-inscr-padrao-novo   LIKE gg-inscricao-padrao.cod-inscricao NO-UNDO. 


    IF  p-cod-inscr-padrao <> 0 THEN DO:
        FIND FIRST gg-inscricao-padrao EXCLUSIVE-LOCK 
             WHERE gg-inscricao-padrao.cod-inscricao = p-cod-inscr-padrao NO-ERROR. 
        IF AVAIL gg-inscricao-padrao THEN
           ASSIGN p-cod-inscr-padrao-novo = p-cod-inscr-padrao.
        ELSE IF NOT CAN-FIND(FIRST gg-inscricao NO-LOCK 
                             WHERE gg-inscricao.cod-emitente = b-emitente.cod-emitente) THEN DO: /*foi deletado e n∆o existe nada*/
            RUN pi-busca-ultima-inscricao-padrao (OUTPUT p-cod-inscr-padrao-novo). 

            CREATE gg-inscricao-padrao.
            ASSIGN gg-inscricao-padrao.cod-inscricao = p-cod-inscr-padrao-novo.
        END.
    END.
    ELSE DO:  
        RUN pi-busca-ultima-inscricao-padrao (OUTPUT p-cod-inscr-padrao-novo). 

        CREATE gg-inscricao-padrao.
        ASSIGN gg-inscricao-padrao.cod-inscricao = p-cod-inscr-padrao-novo. 
    END.

    IF p-cod-inscr-padrao-novo > 0 THEN DO: 
       ASSIGN gg-inscricao-padrao.log-equiparado                   = NO
              gg-inscricao-padrao.ins-estadual                     = b-emitente.ins-estadual
              gg-inscricao-padrao.nom-inscricao                    = b-emitente.nome-emit
              gg-inscricao-padrao.endereco                         = b-emitente.endereco
              gg-inscricao-padrao.bairro                           = b-emitente.bairro
              gg-inscricao-padrao.cidade                           = b-emitente.cidade
              gg-inscricao-padrao.estado                           = b-emitente.estado
              gg-inscricao-padrao.cep                              = b-emitente.cep
              gg-inscricao-padrao.pais                             = b-emitente.pais
              gg-inscricao-padrao.telefone                         = b-emitente.telefone[1]
              gg-inscricao-padrao.ramal                            = b-emitente.ramal[1] 
              gg-inscricao-padrao.ins-municipal                    = b-emitente.ins-municipal
              gg-inscricao-padrao.e-mail                           = b-emitente.e-mail
              gg-inscricao-padrao.complemento                      = b-emitente.endereco2
              gg-inscricao-padrao.nom-contato                      = b-emitente.nome-emit
              gg-inscricao-padrao.cgc                              = b-emitente.cgc
              gg-inscricao-padrao.cod-propriet                     = string(b-emitente.cod-emitente).

       RELEASE gg-inscricao-padrao.

    END.

    RETURN "OK":U.

END PROCEDURE. 


PROCEDURE pi-busca-ultima-inscricao-padrao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-inscricao AS INT NO-UNDO.
    
    FIND LAST gg-inscricao-padrao NO-LOCK NO-ERROR.
    IF AVAIL  gg-inscricao-padrao THEN
        ASSIGN p-inscricao =  gg-inscricao-padrao.cod-inscricao + 1.
    ELSE 
        ASSIGN p-inscricao = 1.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-busca-ultima-inscricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-inscricao AS INT NO-UNDO.
    
    FIND LAST gg-inscricao NO-LOCK 
        WHERE gg-inscricao.cod-emitente  = b-emitente.cod-emitente NO-ERROR. 

    IF AVAIL  gg-inscricao THEN
        ASSIGN p-inscricao =  gg-inscricao.cod-inscricao + 1.
    ELSE 
        ASSIGN p-inscricao = 1.

    RETURN "OK":U.

END PROCEDURE.





