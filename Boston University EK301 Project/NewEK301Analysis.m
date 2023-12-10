%receive input

our_struct = open('TrussDesign3_PreeSantiagoH_A6.mat');
C = our_struct.C;
L = our_struct.L;
Sx = our_struct.Sx;
Sy = our_struct.Sy;
X = our_struct.X;
Y = our_struct.Y;

[num_joint,num_member] = size(C);

%identify the max buckling for esch member
uncertainty = 1.685; %in oz
max_load_each = [];
length_member = [];
for i = 1:num_member
    % (a,i)
    x=[];
    y=[];
    for j = 1:num_joint
        if C(j,i) == 1
            x=[x;X(j)]; 
            y=[y;Y(j)];
        end
    end
    lengthofmem =((x(1)-x(2))^2+(y(1)-y(2))^2)^0.5;

    length_member = [length_member,lengthofmem];
    max_load_each = [max_load_each;3654.533*(lengthofmem)^(-2.119)];%based on class buckling lab data
end

%find the joint that weight applied
for i = 1:length(L)
    if L(i) ~= 0
        weight_joint = i;
        break
    end
end

%Creating Matrix A
A = zeros(2*num_joint,num_member+3);
A(1:num_joint,num_member+1:num_member+3) = Sx;
A(num_joint+1:2*num_joint,num_member+1:num_member+3) = Sy;

%substitue force equilibrium component in the matrix
for i = 1:num_joint
    for j = 1:num_member
        if C(i,j) == 1
            for m = 1:num_joint
                if (C(m,j)==1) && (m ~= i)
                    A(i,j)=(X(m)-X(i))/length_member(j);
                    A(num_joint+i,j)=(Y(m)-Y(i))/length_member(j);
                end
            end
        end
    end
end

%analysis to find the max weight by starting with 32 oz
%keep it in the while loop to increase weight by 0.1 oz until it buckles
%in while loop include for loop to check member1-21 to see if it would buckle
%by check if it's compression and exceed the maximum force the member can
%handle or not if it's break, at the end, we have to go down 1 step to get
%the actual max load
T = A^(-1)*L;
state = true;
while state
    L(weight_joint)=L(weight_joint)+0.1;
    T = A^(-1)*L;
    for i = 1:num_member
        if (max_load_each(i)<abs(T(i))) && (T(i)<0)
            state = false;
            critical_member = i;
            break
        end
    end
end
L(weight_joint) = L(weight_joint)-0.1;
T = A^(-1)*L;

%calculate uncertainty of final weight
uncertainty_weight = uncertainty*L(weight_joint)/abs(T(critical_member));

%display output and identify the critical member
fprintf('EK301, Section A6, Group 10, Final Design: Pree S., Santiago H., 12/05/2023.\n');
fprintf('Load: %.2f oz\n Member forces in oz\n',L(weight_joint));
for i = 1:num_member
    if T(i)>=0
        fprintf('m%d: %.3f (T)\n',i,T(i));
    else
        fprintf('m%d: %.3f (C)\n',i,-T(i));
    end
end
fprintf('Reaction forces in oz:\n');
fprintf('Sx1: %.3f\n',T(num_member+1));
fprintf('Sy1: %.3f\n',T(num_member+2));
fprintf('Sy2: %.3f\n',T(num_member+3));
cost = 10*num_joint+sum(length_member);
fprintf('Uncertainty in oz: %.3f\n',uncertainty_weight);
fprintf('The critical member: %d\n',critical_member);
if max_load_each(critical_member)<abs(T(critical_member))
    fprintf('The model can handle less than 32 oz\n');
end
fprintf('Cost of truss: $%.2f\n',cost);
fprintf('Theoretical max load/cost ratio in oz/$: %.6f\n',L(weight_joint)/cost);
