# HelloFax API

Register on [https://www.hellofax.com](https://www.hellofax.com) to obtain an account and GUID.

Due to an [outstanding issue](https://github.com/jwagener/httmultiparty/issues/10) with HTTMultiParty we can only send one document at a time.

HelloFax developer is allowing 10 files per request.
> I'm thinking that I'll limit the number of files to 10 and the total upload size to 30 MB and give an immediate, synchronous error for both these cases. I'll also limit faxes to a total of 200 pages and return an error in the callback (since I can't determine number of pages quickly enough to give a synchronous error).

The API documentation is not exposed anywhere but this wrapper consists of all the functionality the API has.

There are the two callback URLs, one for inbound and one for outbound, that can be set through `update_account_details`.

Then all you need to do is:

```
$hello_fax = HelloFax::API.new("email@address.com", 'password', 'guid') # this belongs in an initializer
$hello_fax.send_fax('5555555555', File.new("file.pdf")).parsed_response
```
