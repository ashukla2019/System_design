What happens when you enter “google.com”?

What is a WebPage  -> Before getting started, I want to first explain what a webpage is. A webpage is basically a text file formatted a
certain way so that your browser (ie. Chrome, Firefox, Safari, etc) can understand it; this format is called HyperText Markup 
Language (HTML). These files are located in computers that provide the service of storing said files and waiting for someone to 
need them to deliver them. They are called servers because they serve the content that they hold to whoever needs it.

Servers -> These servers can vary in classes, the most common and the one that we'll be talking about in the main portion of 
this article is a web server, the one that serves web pages. We can also find application servers, which are the ones that hold 
an application base code that will then be used to interact with a web browser or other applications. Database servers are also
out there, which are the ones that hold a database that can be updated and consulted when needed.

IP Addresses -> These servers in order to deliver their content, much like in physical courier services, need to have an address 
so that the person needing to be said content can make a "letter" requesting the delivery; the person requesting the content in
turn also has an address where the server can deliver the content to. These addresses are called IP (Internet Protocol) Addresses, 
a set of 4 numbers that range from 0 to 255 (one byte) separated by periods (ie. 127.0.0.1).

Protocols for Delivery -> Another concept that is important to know is that the courier service traffic for the delivery can be one of
two: Transmission Control Protocol (TCP) and User Datagram Protocol (UDP). Each one determines the way the content of a server 
is served or delivered.
4.1 TCP -> TCP is usually used to deliver static websites such as Wikipedia or Google and also email services and to download files 
to your computer because TCP makes sure that all the content that is needed gets delivered. It accomplishes this by 
sending the file in small packets of data and along with each packet a confirmation to know that the packet was delivered;
that's why if you are ever downloading something and your internet connection suddenly drops when it comes back up you don't have 
to start over because the server would know exactly how many packets you have and how many you still need to receive. 
The downside to TCP is that because it has to confirm whether you got the packet or not before sending the next, 
it tends to be slower.

4.2 UDP-> UDP, on the other hand, is usually used to serve live videos or online games. This is because UDP is a lot faster than TCP
since UDP does not check if the information was received or not; it is not important. The only thing UDP cares about is 
sending the information. That is the reason why if you've ever watched a live video and if either your internet connection 
or the host's drops, you would just stop seeing the content; and when the connection comes back up you will only see the 
current stream of the broadcast and what was missed is forever lost. This is also true for online videogames 
(if you've played them you know exactly what this means)

What Actually happens….
So back to the main question of what happens when you type www.google.com or any other URL (Uniform Resource Locator) in your web
browser and press Enter. 

So the first thing that happens is that your browser looks up in its cache to see if that website was visited before and the IP address
is known. If it can't find the IP address for the URL requested then it asks your operating system to locate the website. The first place your operating system is going to check for the address of the URL you specified is in the host file. If the URL is not found inside this file, then the OS will make a DNS request to find the IP Address of the web page.
The first step is to ask the Resolver (or Internet Service Provider) server to look up its cache to see if it knows the IP Address, if the Resolver does not know then it asks the root server to ask the .COM TLD (Top Level Domain) server - if your URL ends in .net then the TLD server would be .NET and so on - the TLD server will again check in its cache to see if the requested IP Address is there. 
If not, then it will have at least one of the authoritative name servers associated with that URL, and after going to the Name Server, it will return the IP Address associated with your URL. All this was done in a matter of milliseconds WOW!
After the OS has the IP Address and gives it to the browser, it then makes a GET (a type of HTTP Method) to said IP Address. When the request is made the browser again makes the request to the OS which then, in turn, packs the request in the TCP traffic protocol we discussed earlier, and it is sent to the IP Address. 
On its way, it is checked by both the OS' and the server's firewall to make sure that there are no security violations. And upon receiving the request the server (usually a load balancer that directs traffic to all available servers for that website) sends a response with the IP Address of the chosen server along with the SSL (Secure Sockets Layer) certificate to initiate a secure session (HTTPS). 
Finally, the chosen server then sends the HTML, CSS, and Javascript files (If any) back to the OS who in turn gives it to the browser to interpret it. And then you get your website as you know it.
