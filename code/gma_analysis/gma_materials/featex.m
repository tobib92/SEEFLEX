## tabulate instances of a feature
MACRO feature($0=NQR $1=feature)
  cat $0 0 0 > "| echo '=====TOKENS $1'";
  tabulate $0 match, matchend, match /text_id[];
  .EOL.;
;

## generate per-text frequency counts directly
MACRO feature_count($0=NQR $1=feature)
  cat $0 0 0 > "| echo '=====COUNTS $1'";
  group $0 match /text_id[];
  .EOL.;
;

## make start/end tags from s-attribute name
MACRO featex_start_tag($0=name)
  <$0>
;
MACRO featex_end_tag($0=name)
  </$0>
;

## aggregate two or more named query results
MACRO union($0=Res $1=Q1 $2=Q2)
  $0 = union $1 $2;
;
MACRO union($0=Res $1=Q1 $2=Q2 $3=Q3)
  _Union_$$ = union $1 $2;
  $0 = union _Union_$$ $3;
  discard _Union_$$;
;
MACRO union($0=Res $1=Q1 $2=Q2 $3=Q3 $4=Q4)
  _Union_$$_A = union $1 $2;
  _Union_$$_B = union $3 $4;
  $0 = union _Union_$$_A _Union_$$_B;
  discard _Union_$$_A;
  discard _Union_$$_B;
;
MACRO union($0=Res $1=Q1 $2=Q2 $3=Q3 $4=Q4 $5=Q5)
  /union[_Union_$$, $1, $2, $3, $4];
  $0 = union _Union_$$ $5;
  discard _Union_$$;
;
MACRO union($0=Res $1=Q1 $2=Q2 $3=Q3 $4=Q4 $5=Q5 $6=Q6)
  /union[_Union_$$_A, $1, $2, $3, $4];
  /union[_Union_$$_B, $5, $6];
  $0 = union _Union_$$_A _Union_$$_B;
  discard _Union_$$_A;
  discard _Union_$$_B;
;
MACRO union($0=Res $1=Q1 $2=Q2 $3=Q3 $4=Q4 $5=Q5 $6=Q6 $7=Q7)
  /union[_Union_$$, $1, $2, $3, $4, $5, $6];
  $0 = union _Union_$$ $7;
  discard _Union_$$;
; 
MACRO union($0=Res $1=Q1 $2=Q2 $3=Q3 $4=Q4 $5=Q5 $6=Q6 $7=Q7 $8=Q8)
  /union[_Union_$$_A, $1, $2, $3, $4];
  /union[_Union_$$_B, $5, $6, $7, $8];
  $0 = union _Union_$$_A _Union_$$_B;
  discard _Union_$$_A;
  discard _Union_$$_B;
;

## initialize feature extraction
MACRO init_corpus()
  _Texts = /featex_start_tag[/text_id[]] [] expand to /text_id[];
  /feature[_Texts, "n_token"];
  discard _Texts;
;

MACRO init_subcorpus($0=Subcorpus)
  /feature[$0, "n_token"];
  $0; # activate subcorpus
;
