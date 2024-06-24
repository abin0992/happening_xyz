
# This is **Super shopping cart simulator** app!

Welcome to your live coding assignment of **Super Shopping cart simulator** (for happening.xyz (superbet)).
We will hang out for about 2 hours, so let's have fun.

We just came from a meeting with product managers and they need to have live
demo in two hours. Please help.

Main app functionality is to hold items in shopping cart and display total sum on
items prices. Available items with prices needs to be fetched from API and displayed in list.

Requirements:
* items needs to be fetched from REST API once on application start
* total price and item count in shopping cart needs to be updated every time item is added
  or removed from shopping cart

Optional/bonus requirements:
* main logic parts of the app needs to be covered with unit tests
* add buy functionality that will call API to make a purchase of items in shopping cart

Good luck and happy coding.

## REST API
Base URL: https://apache.superology.dev/interview

### Get all products
#### Request
GET `/getAllProducts`

### Response
```json
{
  "data": {
    "products": [
      {
        "id": "7aa080fd-aafc-4cd7-9d26-030457708297",
        "name": "Bread"
      },
      {
        "id": "05313b70-ffc8-40c0-958c-46f595b75ea9",
        "name": "Milk"
      },
      {
        "id": "d3eb4223-5104-426c-a456-5f5650b53e99",
        "name": "Eggs"
      }
    ],
    "prices": [
      {
        "id": "05313b70-ffc8-40c0-958c-46f595b75ea9",
        "price": 0.94
      },
      {
        "id": "d3eb4223-5104-426c-a456-5f5650b53e99",
        "price": 2.45
      },
      {
        "id": "7aa080fd-aafc-4cd7-9d26-030457708297",
        "price": 1.25
      }
    ]
  }
}
```

## Purchase products

#### Request

POST `/purchaseProducts`

Body
```json
{
  "products": [
    {
      "id": "7aa080fd-aafc-4cd7-9d26-030457708297",
      "amount": 1
    },
    {
      "id": "d3eb4223-5104-426c-a456-5f5650b53e99",
      "amount": 2
    }
  ]
}
```

### Response
Success
**Status: 201**
  ```json
  {
      "message": "Products purchased!"
  }
  ```
Error - invalid request
**Status: 400**
  ```json
  {
      "message": "Request body must be a non-empty array of products."
  }
  ```

<img src="https://github.com/superology-ios/shopping-cart-interview/assets/97449072/e507bcdd-f94b-437a-9aea-5e91d493bd9a" alt="app" width="300">

iOS live coding challenge, the interviewers expect to finish this in 90 minutes
happening.xyz
superbet 
