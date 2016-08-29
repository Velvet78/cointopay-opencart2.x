<form action="<?php echo $action; ?>" method="post" class="form-horizontal">
  <input type="hidden" name="price" value="<?php echo $price; ?>" />
  <input type="hidden" name="key" value="<?php echo $key; ?>" />
<!--  <input type="hidden" name="AltCoinID" value="<?php //echo $AltCoinID; ?>" />-->
  
  <div class="form-group">
      <label class="col-sm-10 control-label" ><?php echo $text_crypto_coin_lable;?></label>
      <div class="col-sm-2">
          <select class="form-control" id="AltCoinID" name="AltCoinID">
              <?php foreach ($crypto_coins as $key => $value) { ?>
                  <option value="<?php echo $key; ?>" <?php if ($key == $AltCoinID) { echo 'selected="selected"'; } ?>><?php echo $value; ?></option>
              <?php } ?>
          </select>
      </div>
  </div>
  <input type="hidden" name="OrderID" value="<?php echo $OrderID; ?>" />
  <input type="hidden" name="currency" value="<?php echo $currency; ?>" />
  <div class="buttons">
    <div class="pull-right">
      <input type="submit" value="<?php echo $button_confirm; ?>" class="btn btn-primary" />
    </div>
  </div>
</form>
