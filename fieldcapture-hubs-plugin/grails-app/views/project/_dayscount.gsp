<style type="text/css">
.dayscount > h2 {
    font-size: 300%;
    text-align: center;
}
.dayscount > h4 {
    color: grey;
    text-align: center;
}
.dayscount-infinite {
    color: green;
}
</style>
<div class="dayscount" data-bind="visible:transients.daysSince() >= 0 && transients.daysRemaining() > 0">
    <h2 data-bind="text:transients.daysRemaining"></h2>
    <h4>DAYS TO GO</h4>
</div>
<div class="dayscount" data-bind="visible:transients.daysSince() >= 0 && transients.daysRemaining() == 0">
    <h4>PROJECT</h4>
    <h4>ENDED</h4>
</div>
<div class="dayscount" data-bind="visible:transients.daysSince() >= 0 && transients.daysRemaining() < 0">
    <h2 class="dayscount-infinite">&infin;</h2>
    <h4>PROJECT</h4>
    <h4>ONGOING</h4>
</div>
<div class="dayscount" data-bind="visible:transients.daysSince() < 0">
    <h4>PROJECT</h4>
    <h4>NOT YET</h4>
    <h4>STARTED</h4>
</div>
