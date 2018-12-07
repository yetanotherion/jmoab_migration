# Mixed moab: a Ann Arbor story part I

--

- The big bang thing doesn't look good

- How to bootstrap things using what we have?

--

- Flying Bridge to Ann Arbor / Beers
.side[![Michigan U.](http://imageproxy-app.marathon-par.central.criteo.preprod/img/img?m=2&w=257&h=600&debug=1&partner=-1&u=https%3A%2F%2Fsharing.wxyz.com%2Fsharewxyz%2Fphoto%2F2016%2F06%2F16%2FUofMlogo_1466109552834_40472428_ver1.0_640_480.jpg&r=0&dpa=0&ups=0&c=0&p=0&q=80&v=1&s=n16AC3vBesz90JWLnNz35jGS)]

- An idea while there:

   - a BuildWithMavenPlugin
   - use the converted gradle projects
   - replace compilation steps with calls to Maven

???
- Lonely nights at the hotel
- Not so lonely nights at the bar
- -7 -> +1 Celsius

???
- Lonely nights at the hotel
- Not so lonely nights at the bar
- -7 -> +1 Celsius


--

- April 2018, JMOAB 1.5 is born!


---
class: center
# An image = a thousand words
![Performance](imgs/JMOABPerf1.png)
???
The performance before the jump doesn't include the packaging step.
The one after the jump does.

---
# JMOAB 1.5

- We have a complete gradle pipeline
- Build times are better
- We can start migration using the converter:


--

- May 2018: [Perpetuo](http://review.criteois.lan/#/c/346423/) is the first gradle repository


--

- June 2018:
   - JMOAB 1.6 - implementing a gradle cache on maven tasks
   - June 15th: WOOT WOOT mail: presubmit faster

---
class: center
# JMOAB 1.6
![Performance](imgs/JMOABPerf2.png)

---
# Mixed moab: a Ann Arbor story part II

--
- JMOAB 1.6 works great on CI
- Impossible to use for devs
- Idea: why not parse the poms directly from gradle?


???
It is a problem that devs can't use a mixed workspace because that means that all repos they work on must be converted before they can switch.

--

- Second Flying Bridge / More beers
- Full mixed gradle/maven support without converter


--

- Time to start cracking on that conversion...

---
