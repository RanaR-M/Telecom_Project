--##Test Procedure 

--------1)Execute the SelectAllCustomers procedure
EXEC SelectAllCustomers;

--------2)Execute SelectCustomersByChurnStatus
-- Test case 1: Select customers with churn status 'Churned'
EXEC SelectCustomersByChurnStatus @ChurnStatus = 'Churned';

-- Test case 2: Select customers with churn status 'Stayed'
EXEC SelectCustomersByChurnStatus @ChurnStatus = 'Stayed';

--------3)Execute DisplayChurnCustomerWithReason
EXEC DisplayChurnCustomerWithReason



