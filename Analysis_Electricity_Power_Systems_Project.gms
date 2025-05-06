$title Optimal_Unit_Scheduling

$Ontext
    ------- Aristotle University of Thessaloniki (AUTH)-------
    ------- Electrical and Computer Engineering (ECE)  -------
           Analysis of Electricity Power Systems Project
           Ioannis Deirmentzoglou AEM : 10015 , deirmentz@ece.auth.gr
$Offtext

Sets

 i    Production Units (Thermal and Hydroelectric) /AgiDim, Komotini, Kremasta, Sfikia, Stratos/
 j(i) Hydroelectric Units                          /Kremasta, Sfikia, Stratos/  
 t    Total hours of time programming horizon      /0*24/
 iData    Unit Data Characteristics                /Pmax, Pmin, Emax, Emin, b, NLC, SUC, SDC, RU, RD, UT, DT, P_ini, T_ini, u_ini/
;

Alias (t,it) ;

Table    UnitData(i,iData)  Unit Data

                 Pmax    Pmin    Emax     Emin       b       NLC     SUC      SDC      RU      RD      UT     DT     P_ini     T_ini    u_ini
    AgiDim       280     160     NA       NA         34      2500    15000    1200     170     170     12     6      0         -10      0
    Komotini     420     180     NA       NA         45      1600    3700     300      360     360     4      3      400       4        1
    Kremasta     300     0       1700     1000       0       0       0        0        300     300     1      1      150       10       1
    Sfikia       250     0       1250     800        0       0       0        0        250     250     1      1      0         -10      0
    Stratos      250     0       1450     700        0       0       0        0        250     250     1      1      0         -15      0
;


Variables
 p(i,t) Power output of unit 'i' at time 't' (MW)
 u(i,t) Binary variable equal to 1 if unit 'i' is running at time 't'
 y(i,t) Binary variable equal to 1 if unit 'i' is synchronized at the beginning of time 't'
 z(i,t) Binary variable equal to 1 if unit 'i' is desynchronized at the beginning of time 't'
 Profit
;

Binary Variable
  u
  y
  z
;

Positive Variables p
                   
;



Parameters
  lamda_t(t) Price of energy at time 't' 
  
  Pmax(i) Maximum net power output of unit 'i'
  Pmin(i) Minimum net power output of unit 'i'
  
  Emax(j) Maximum electricity production of hydroelectric unit 'i'
  Emin(j) Minimum electricity production of hydroelectric unit 'i'
  
  b(i)    Differential operating cost of unit 'i'
  NLC(i)  Fixed operating cost of unit 'i'
  SUC(i)  Startup cost of unit 'i'
  SDC(i)  Booking cost of unit 'i'
  
  RU(i)   Maximum rate of increase of power output of unit 'i'
  RD(i)   Maximum rate of reduction of power output of unit 'i'
  
  UT(i)   Minimum operating time of unit 'i'
  DT(i)   Minimum holding time of unit 'i'
  
  P_ini(i) Output power of unit 'i' at the beginning of the programming horizon
  T_ini(i) Number of hours unit 'i' was on or off at its start planning horizon
  u_ini(i) Operating state of unit 'i' at the beginning of the planning horizon
;

 Pmax(i) = UnitData(i,"Pmax")   ;
 Pmin(i) = UnitData(i,"Pmin")   ;
 
 Emax(j) = UnitData(j,"Emax")   ;
 Emin(j) = UnitData(j,"Emin")   ;
 
 b(i)     = UnitData(i,"b")     ;
 NLC(i)   = UnitData(i,"NLC")   ;
 SUC(i)   = UnitData(i,"SUC")   ;
 SDC(i)   = UnitData(i,"SDC")   ;
 
 RU(i)    = UnitData(i,"RU")    ;
 RD(i)    = UnitData(i,"RD")    ;
 
 UT(i)    = UnitData(i,"UT")    ;
 DT(i)    = UnitData(i,"DT")    ;
 
 P_ini(i) = UnitData(i,"P_ini") ;
 T_ini(i) = UnitData(i,"T_ini") ;
 u_ini(i) = UnitData(i,"u_ini") ;
 


Parameters

    lamda_t(t)   Energy Price /
    1             37.9
    2             37.1
    3             35.9 
    4             34.9
    5             32.3 
    6             31.5
    7             27.8
    8             47.8
    9             64.4
    10            69.7
    11            71.9
    12            75.7
    13            81
    14            87.9
    15            85.2
    16            68.2
    17            63.7
    18            52.4
    19            48.9
    20            62.6
    21            78.5
    22            81.9
    23            70.5
    24            70
  /
;
    

* Initial conditions
p.fx(i,t)$(ord(t)=1) = P_ini(i) ;
u.fx(i,t)$(ord(t)=1) = u_ini(i) ;

y.fx(i,t)$(ord(t)=1 and T_ini(i)=1)  = 1 ;
z.fx(i,t)$(ord(t)=1 and T_ini(i)=-1) = 1 ;

Display p.l ; 
Display u.l ;
Display y.l ;
Display z.l ; 

Parameters
    Tmax1
    F(i)
    L(i)
;

Scalar
    Tmax 'number of hours of the planning period' /24/
;



L(i) = min( Tmax , (UT(i)-T_ini(i))*u_ini(i) ) ;
F(i) = min( Tmax , (DT(i)+T_ini(i))*(1-u_ini(i)) ) ;

Display L ;
Display F ;

u.fx(i,t)$( (ord(t)<= L(i)) and  ord(t)>1  and L(i)>0 and T_ini(i)>0 ) = 1 ;
u.fx(i,t)$( (ord(t)<= F(i)) and  ord(t)>1  and F(i)>0 and T_ini(i)<0 ) = 0 ; 

Scalar

   ProgTime       'number of hours of the planning period' /24/
;



**Objective Function to be Maximized 
Equation Total_Profit Total profit over all units and time periods ;
         Total_Profit.. Profit =e= Sum((i,t)$(ord(t)>1),lamda_t(t) * p(i,t) - (NLC(i)*u(i,t) + b(i)*p(i,t) + SUC(i)*y(i,t) + SDC(i)*z(i,t))  ) ;


*Constraints

Equation Minimum_Operating_Time Minimum Operating Time (UTi h) of unit 'i' costraint ; 
         Minimum_Operating_Time(i,t)$(ord(t)>1) .. Sum(it $ ((ord(it) >= ord(t)- UT(i)+1) and (ord(it)<=ord(t))),y(i,it)) =l= u(i,t) ; 

Equation Minimum_Holding_Time Minimum Holding Time (DTi h) of unit 'i'constraint ;
         Minimum_Holding_Time(i,t)$(ord(t)>1) .. Sum( it $ ((ord(it) >= ord(t)- DT(i)+1) and (ord(it)<=ord(t))), z(i,it) ) =l= 1- u(i,t) ;
         
Equation Transition_Online_Offline Transition of unit 'i' from Online in Off-line mode and vice versa constraint ;
         Transition_Online_Offline(i,t)$(ord(t)>1) .. y(i,t) - z(i,t) =e= u(i,t) - u(i,t-1) ;
         
Equation State_Initialization_Desynchronization  Initialization and Desynchronization State at a specific time 't' constraint ;
         State_Initialization_Desynchronization(i,t)$(ord(t)>1) .. y(i,t) + z(i,t) =l= 1 ;
         

*Maximum and minimum output power constraints

Equation Minimum_Power_Online Minimum Power of unit 'i'(Online) at a specific time 't' constraint ;
         Minimum_Power_Online(i,t)$(ord(t)>1).. p(i,t) =g= Pmin(i) * u(i,t) ;

Equation Maximum_Power_RD_Desynchronization ;
         Maximum_Power_RD_Desynchronization(i,t)$(ord(t)>1).. p(i,t) =l= Pmax(i) * (u(i,t) - z(i,t+1)) + RD(i) * z(i,t+1) ;
         
Equation Power_Increase_RU ;
         Power_Increase_RU(i,t)$(ord(t)>1).. p(i,t) =l= p(i,t-1) + RU(i) ;
         
Equation Power_Decrease_RD ;
         Power_Decrease_RD(i,t)$(ord(t)>1).. p(i,t-1) =l= p(i,t) + RD(i) ;
         

* Energy limitation of hydroelectric units

Equation Energy_Minimum_Limitation_Hydroelectric(j) Minimum Energy limitation of hydroelectric units costraint ;
         Energy_Minimum_Limitation_Hydroelectric(j).. Emin(j) =l= Sum(t$(ord(t)>1),p(j,t)) ; 

Equation Energy_Maximum_Limitation_Hydroelectric(j) Maximum Energy limitation of hydroelectric units costraint ;
         Energy_Maximum_Limitation_Hydroelectric(j).. Sum(t$(ord(t)>1),p(j,t)) =l= Emax(j) ;



Model Optimal_Unit_Scheduling /all/


Option MIQCP = Gurobi ;


Solve Optimal_Unit_Scheduling maximizing Profit using MIQCP ;


Display "Unit Power Output", p.l ;
Display "Unit Status", u.l ;
Display "Unit Commitment", y.l ;
Display "Unit Decommitment", z.l ;
Display "Total Profit", Profit.l;
