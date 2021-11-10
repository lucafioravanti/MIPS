/* https://www.onlinegdb.com/online_c_compiler */

#include<stdio.h>
#include <stdlib.h>
int main()
{
    int i,j,num=1,n,space;
    scanf("%d",&n);  //rows number

    for (i=0;i<n;i++) //loop for rows
    {  
    
        for (space=i;space<n;space++) //loop for spaces
        { 
            printf("  "); // 2
        }
    
        for (j=0;j<=i;j++) //loop for coefficient
        {  
    
            if (j == 0 || i == j)//checks for position
                num=1;
            else
                num = num*(i-j+1)/j;
    
            printf("   %d",num);   // 3 + print coeff
        }
        printf("\n");  //new line
    }   
    
}

