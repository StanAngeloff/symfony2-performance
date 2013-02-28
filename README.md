Symfony2 Performance
====================

A quick repository to run [a benchmark](https://gist.github.com/dlsniper/4707496) against Symfony2 [default distributions](https://github.com/symfony/symfony-standard/issues/464#issuecomment-13107583) in a VirtualBox machine.

Results
-------

Obtained on a `Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz` with `6018184 kB` of memory.

See `Vagrantfile` for virtual machine configuration.

<table>
<caption>Requests per second:</caption>
<tr><th>Release</th><th>Iteration 1</th><th>Iteration 2</th><th>Iteration 3</th><th>Iteration 4</th><th>Iteration 5</th><th>Average</th></tr>
<tr><th>symfony-2.0.22</th><td>70.07</td><td>77.20</td><td>77.20</td><td>77.81</td><td>75.86</td><td>75.6280</td></tr>
<tr><th>symfony-2.1.7</th><td>61.29</td><td>61.18</td><td>61.05</td><td>60.75</td><td>62.20</td><td>61.2940</td></tr>
<tr><th>symfony-2.2.x-dev</th><td>45.12</td><td>41.29</td><td>42.66</td><td>44.86</td><td>45.52</td><td>43.8900</td></tr>
</table>

<table>
<caption>Time per request:</caption>
<tr><th>Release</th><th>Iteration 1</th><th>Iteration 2</th><th>Iteration 3</th><th>Iteration 4</th><th>Iteration 5</th><th>Average</th></tr>
<tr><th>symfony-2.0.22</th><td>356.800</td><td>323.825</td><td>323.815</td><td>321.292</td><td>329.575</td><td>331.0614</td></tr>
<tr><th>symfony-2.1.7</th><td>407.871</td><td>408.639</td><td>409.468</td><td>411.507</td><td>401.915</td><td>407.8800</td></tr>
<tr><th>symfony-2.2.x-dev</th><td>554.042</td><td>605.465</td><td>585.973</td><td>557.288</td><td>549.251</td><td>570.4038</td></tr>
</table>
