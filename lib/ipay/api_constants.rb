module IPay
  EM_SWIPED             = 1
  EM_MANUAL_PRESENT     = 2
  EM_MANUAL_NOT_PRESENT = 3
  
  GOODS_DIGITAL   = 'D'
  GOODS_PHYSICAL  = 'P'
  
  CUR_DOMESTIC = 0
  CUR_MCP      = 1
  CUR_PYC      = 2
  
  TXN_VIA_MAIL      = 'M'
  TXN_VIA_POS       = 'P'
  TXN_VIA_PHONE     = 'T'
  TXN_VIA_RECUR     = 2
  TXN_AUTHENTICATED = 5
  TXN_AUTH_FAILED   = 6
  TXN_VIA_HTTPS     = 7
end