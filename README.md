# HelloFax API

Register on [https://www.hellofax.com](https://www.hellofax.com) to obtain an account and GUID.

HelloFax developer is allowing 10 files per request.

> I'm thinking that I'll limit the number of files to 10 and the total upload size to 30 MB and give an immediate, synchronous error for both these cases. I'll also limit faxes to a total of 200 pages and return an error in the callback (since I can't determine number of pages quickly enough to give a synchronous error).

The API documentation is not exposed anywhere but this wrapper consists of all the functionality the API has.

There are the two callback URLs, one for inbound and one for outbound, that can be set through `update_account_details`.

Then all you need to do is:

```
$hello_fax = HelloFax::API.new("email@address.com", 'password', 'guid') # this belongs in an initializer
$hello_fax.send_fax('555123456', File.new("file.pdf"))
```

This returns an HTTPary::Response object which you can call `#parsed_response` on to convert the JSON in the reponse to Ruby.

# Walkthrough

Sign up for a paid account at https://www.hellofax.com/info/pricing

Go to https://www.hellofax.com/account/apiInfo and take note of your Account GUID. You'll need this for most API requests.

Make your first API request and get your account's configuration info. Make sure to URI encode.

```
curl "https://[joseph%40hellofax.com]:[fakepassword]@www.hellofax.com/apiapp.php/v1/Accounts/[Your Account GUID]"
```

The response will be a JSON representation of the account settings of yours.

Let's turn off email notifications (for outbound and inbound faxes) for your account by making a POST:

```
curl -d "ShouldSendConfEmails=false" "https://[joseph%40hellofax.com]:[fakepassword]@www.hellofax.com/apiapp.php/v1/Accounts/[Your Account GUID]"
```

Let's add callback URLs for your inbound and outbound faxes (again, with a POST):

```
curl -d "AreaCode=415" "https://[joseph%40hellofax.com]:[fakepassword]@www.hellofax.com/apiapp.php/v1/Accounts/[Your Account GUID]/FaxLines"
```

Let's see what fax lines we have at our disposal:

```
curl "https://[joseph%40hellofax.com]:[fakepassword]@www.hellofax.com/apiapp.php/v1/Accounts/[Your Account GUID]/FaxLines"
```

The response should contain the FaxLine you selected when signing up for a premium subscription.

Let's purchase a fax number. First, we need to see what area codes are available in our state (not all area codes are available) with a GET:

```
curl "https://[joseph%40hellofax.com]:[fakepassword]@www.hellofax.com/apiapp.php/v1/AreaCodes?StateCode=CA"
```

Purchase a fax line from one of the available area codes in step 7

```
curl -d "AreaCode=[area code from step 7]" "https://[joseph%40hellofax.com]:[fakepassword]@www.hellofax.com/apiapp.php/v1/Accounts/[Your Account GUID]/FaxLines"
```

Now let's actually send a fax! Right now the API can only handle one file at a time:

```
curl -F file=@fax.html "https://[joseph%40hellofax.com]:[fakepassword]@www.hellofax.com/apiapp.php/v1/Accounts/[Your Account GUID]/Transmissions?To=5555555555"
```

This will begin the process of sending the fax. Just because you get a 200 HTTP response to this call does not mean that the fax will go through or even be sent (a file conversion error could occur). However, once the fax's StatusCode becomes E (for Error) or S (for Success) you will get a POST back to the callback URL you specified in step #5.

Possible StatusCode values:

```
T = transmitting/sending
P = pending/converting
S = successfully sent
E = error; failed to convert or to send fully
H = on hold. You shouldn't ever see this but if you do, treat it as an error.
```

NOTE: The CallerID on all the faxes will show up as "Restricted" or "Unknown" to the recipient

Check the status of the fax you initiated in step #9:

```
curl "https://[joseph%40hellofax.com]:[fakepassword]@www.hellofax.com/apiapp.php/v1/Accounts/[Your Account GUID]/Transmissions/[Transmission GUID]"
```

The Transmission GUID can be found in the JSON response returned from the API call in step #6. If you wamt, you can check the status of all your Transmissions by omitting the Transmission GUID:

```
curl "https://[joseph%40hellofax.com]:[fakepassword]@www.hellofax.com/apiapp.php/v1/Accounts/[Your Account GUID]/Transmissions"
```

Note that these results are paged. You can get different pages by specifying the Page and PageSize url parameters. See the FirstPageUri, NextPageUri, PreviousPageUri, and LastPageUri response elements to get a better idea of how the paging works.

After the status code of the fax gets set to S or E you'll also want to verify that your outbound fax callback URL was hit. It should receive a POST with a parameter called 'json' that contains everything you'd get in the response to a call like you made in step #10.

If you happened to send the fax to your own fax number (silly in real life, but useful for testing), you should also verify that your inbound fax callback URL was hit as well.
