%Modelo
syms R L g m Km x1 x2 x3 u
dx=[-R/L*x1+1/L*u;x3;g-Km/(2*m)*(x1/x2)^2];
y=x2;

%Punto de equilibrio
Peq=solve(dx==0,{x1,x3,u});
Ieq=Peq.x1(1);
veq=Peq.x3(1);
Ueq=Peq.u(1);

%Linealización
As=jacobian(dx,[x1,x2,x3]);
Bs=jacobian(dx,u);
Cs=jacobian(y,[x1,x2,x3]);

%Init Maglev
Rn=9.72;
Ln=0.41;
gn=9.79;
mn=0.068;
Kmn=8.5e-5;
%Kmn=6.2391e-5;
%Kmn=6.5308e-5;
Zeq=0.009;

Xeq=double(subs([Ieq;x2;0],{x2,m,g,Km,L},{Zeq,mn,gn,Kmn,Ln}));
Ueq=double(subs(Ueq,{x2,m,g,Km,L,R},{Zeq,mn,gn,Kmn,Ln,Rn}));
x0=Xeq+diag([-0.1;0.05;0])*Xeq;
xh0=zeros(2,1);

A=double(subs((subs(As,{x1,x2,x3,u},{Ieq,Zeq,veq,Ueq})),{x2,m,g,Km,L,R},{Zeq,mn,gn,Kmn,Ln,Rn}));
B=double(subs((subs(Bs,{x1,x2,x3,u},{Ieq,Zeq,veq,Ueq})),{x2,m,g,Km,L,R},{Zeq,mn,gn,Kmn,Ln,Rn}));
C=double(subs((subs(Cs,{x1,x2,x3,u},{Ieq,Zeq,veq,Ueq})),{x2,m,g,Km,L,R},{Zeq,mn,gn,Kmn,Ln,Rn}));

Aa=[A,zeros(3,1);-C,0];
Ba=[[B;0]];Bd=[zeros(3,1);1];
Ca=[C,0];

% Diseño de control
Q=diag([100,1,1,1000]);R=1;
K=lqr(Aa,Ba,Q,R);
K1p=K([1,3]);K2=K(2);Ki=K(4);
Kl=lqr(A,B,diag([100,1,100]),1);

%Diseño del observador
T12=[1,0];
T32=[0,1];
Ao11=0;
Ao12=[0,1];
Ao21=[0;2*gn/(Zeq)];
Ao22=[-Rn/Ln,0;-1/Zeq*sqrt(2*Kmn*gn/mn),0];

Bo1=0;
Bo2=[1/Ln;0];
xh0=[0;0];

W=diag([1,1]);V=diag([1]);
%Ko=lqr(Ao22',Ao12',W,V)';
Ko=place(Ao22',Ao12',[-160+100j,-160-100j])';