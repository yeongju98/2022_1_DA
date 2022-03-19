#2020121049 지영주 YBIGTA SQL 과제 제출

#1번
select country, count(distinct offices.officeCode) as office수, 
count(employeeNumber) as employee수 from offices
left join employees 
on offices.officeCode = employees.officeCode
group by 1
order by 1;



#2번
SELECT customerNumber, customerName, contactFirstName 
FROM (select * from customers
where customerNumber is not null) as not_null_customers
where contactFirstName like 'R%'
order by 1;


#3번
select count(orders.customerNumber) from orders
left join customers
on orders.customerNumber = customers.customerNumber
where country = 'USA'
and status in ('Cancelled', 'On Hold');


#4번
select officeCode from (select officeCode, count(distinct customerNumber) from employees
left join customers
on employees.employeeNumber = customers.salesRepEmployeeNumber
group by 1
order by 2 DESC
limit 1) as 가장많은고객;


#5번-첫번째방법: 서브쿼리 이용
select customerName, country, phone from customers
left join payments
on payments.customerNumber = customers.customerNumber
where amount in
(select max(결제금액) 
from (select sum(amount) as 결제금액 from payments
where extract(year from paymentDate)=2004
and extract(month from paymentDate) = 11
group by customerNumber) payment);

#5번-두번째방법: 한번에 join 후 order
select payments.customerNumber, customerName, country, phone, 
paymentDate, sum(amount) from payments
left join customers
on payments.customerNumber = customers.customerNumber
where extract(year from paymentDate)=2004
and extract(month from paymentDate) = 11
group by customerNumber
order by 6 DESC
limit 1;


#6번
select max(배송기간), min(배송기간) from 
(select dateDiff(shippedDate,orderDate) as 배송기간 from orders
where extract(year from orderDate) = 2005
and extract(month from orderDate) = 1) orders;


#7번-첫번째방법: 서브쿼리 이용
select * from (select * from employees where employeeNumber is not null) employees
where employeeNumber = (select salesRepEmployeeNumber
 from (select payments.customerNumber, sum(amount), 
salesRepEmployeeNumber
from payments
left join customers
on payments.customerNumber = customers.customerNumber
where extract(year from paymentDate) = 2004
group by 1
order by 2 DESC
limit 1) employees);

#7번-두번째방법: join, order 이용
select employeeNumber, lastName, firstName,
extension, email, officeCode, reportsTo, jobtitle, customers.customerNumber,
paymentDate, sum(amount) from employees
left join customers
on employees.employeeNumber = customers.salesRepEmployeeNumber
left join payments
on customers.customerNumber = payments.customerNumber
group by 9
order by 11 desc
limit 1;