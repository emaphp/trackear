function updateInvoiceTotal() {
    var $form = $('#invoice-form');
    var $discount_percentage = $form.find('.discount-percentage');
    var $total = $form.find('.invoice-total');
    var $entries = $form.find('.entry');
    var total = 0;
    $entries.each(function(index, entry) {
        var $entry = $(entry);
        var $rate = $entry.find('.rate');
        var $from = $entry.find('.from');
        var $to = $entry.find('.to');
        var $quantity = $entry.find('.quantity');
        var $entry_total = $entry.find('.total');
        var diff_hours = moment($to.val()).diff(moment($from.val()), 'hours', true);
        var entry_total = diff_hours * $rate.val();

        $quantity.text(diff_hours.toFixed(2));
        $entry_total.text(entry_total.toFixed(2));

        total += entry_total;
    });

    total *= (100 - $discount_percentage.val()) / 100;
    $total.text(total.toFixed(2));
}

$(updateInvoiceTotal);