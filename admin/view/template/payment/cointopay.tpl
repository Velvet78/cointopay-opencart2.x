<?php echo $header; ?><?php echo $menu; ?>
<div id="content">
    <div class="page-header">
        <div class="container-fluid">
            <div class="pull-right">
                <button type="submit" form="form-cointopay" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary"><i class="fa fa-save"></i></button>
                <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a></div>
            <h1><i class="fa fa-credit-card"></i> <?php echo $heading_title; ?></h1>
        </div>
    </div>
    <div class="container-fluid">
        <?php if (isset($error['error_warning'])) { ?>
            <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error['error_warning']; ?>
                <button type="button" class="close" data-dismiss="alert">&times;</button>
            </div>
        <?php } ?>
        <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-cointopay" class="form-horizontal">
            <script type="text/javascript">
                <?php if((isset($cointopay_merchantID) && !empty($cointopay_merchantID)) && (isset($cointopay_crypto_coin) && empty($cointopay_crypto_coin))){?>
                    $(document).ready(function(){
                        getMerchantCoin('<?php echo $cointopay_merchantID;?>');
                    });
                <?php } ?>
                function getMerchantCoin(merchantId)
                {
                    $.ajax({
                        url:'index.php?route=payment/cointopay/getMerchantCoinsByAjax&token=<?php echo $token?>',
                        type:'post',
                        data:{merchantId:merchantId},
                        success:function(res){
                            $('#cointopay_crypto_coin').html(res);
                        }
                    });
                }
            </script>
            <ul class="nav nav-tabs">
                <li class="active"><a href="#tab-general" data-toggle="tab"><?php echo $tab_general; ?></a></li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="tab-general">
                    <div class="form-group required">
                        <label class="col-sm-2 control-label" for="entry-display-name"><span data-toggle="tooltip" title="<?php echo $help_display_name_hint; ?>"><?php echo $entry_display_name; ?></span></label>
                        <div class="col-sm-10">
                            <input type="text" name="cointopay_display_name" value="<?php echo $cointopay_display_name; ?>" placeholder="<?php echo $entry_display_name; ?>" id="cointopay_display_name" class="form-control"/>
                            <?php if ($error_display_name) { ?>
                                <div class="text-danger"><?php echo $error_display_name; ?></div>
                            <?php } ?>
                        </div>
                    </div>
                    <div class="form-group required">
                        <label class="col-sm-2 control-label" for="entry-api-key"><span data-toggle="tooltip" title="<?php echo $help_api_key_hint; ?>"><?php echo $entry_api_key; ?></span></label>
                        <div class="col-sm-10">
                            <input type="text" name="cointopay_api_key" value="<?php echo $cointopay_api_key; ?>" placeholder="<?php echo $entry_api_key; ?>" id="cointopay_api_key" class="form-control"/>
                            <?php if ($error_api_key) { ?>
                                <div class="text-danger"><?php echo $error_api_key; ?></div>
                            <?php } ?>
                        </div>
                    </div>
                    <div class="form-group required">
                        <label class="col-sm-2 control-label" for="entry-merchantID"><span data-toggle="tooltip" title="<?php echo $help_merchantID_hint; ?>"><?php echo $entry_merchantID; ?></span></label>
                        <div class="col-sm-10">
                            <input type="text" name="cointopay_merchantID" value="<?php echo $cointopay_merchantID; ?>" placeholder="<?php echo $entry_merchantID; ?>" id="cointopay_merchantID" class="form-control" onchange="getMerchantCoin(this.value);"/>
                            <?php if ($error_merchantID) { ?>
                                <div class="text-danger"><?php echo $error_merchantID; ?></div>
                            <?php } ?>
                        </div>
                    </div>
                    <div class="form-group required">
                        <label class="col-sm-2 control-label" for="entry-crypto-coin"><span data-toggle="tooltip" title="<?php echo $help_crypto_coin_hint; ?>"><?php echo $entry_crypto_coin; ?></span></label>
                        <div class="col-sm-10">
                            <select name="cointopay_crypto_coin" id="cointopay_crypto_coin" class="form-control">
                                <?php if($cointopay_crypto_coin && !empty($cointopay_crypto_coin)) {?>
                                    <option value="">Select Default Coin</option>
                                    <?php foreach ($crypto_coins as $key=>$value) { ?>
                                        <option value="<?php echo $key;?>" <?php if($key == $cointopay_crypto_coin){echo 'selected="selected"';}?>><?php echo $value;?></option>
                                    <?php } ?>
                                <?php }else{?>
                                    <option value="">Select Default Coin</option>    
                                <?php } ?>        
                            </select>
                            <?php if ($error_crypto_coin) { ?>
                                <div class="text-danger"><?php echo $error_crypto_coin; ?></div>
                            <?php } ?>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-order-status"><?php echo $entry_order_status; ?></label>
                        <div class="col-sm-10">
                            <select name="cointopay_order_status_id" id="cointopay_order_status_id" class="form-control">
                                <?php foreach ($order_statuses as $order_status) { ?>
                                    <?php if ($order_status['order_status_id'] == $cointopay_order_status_id) { ?>
                                        <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                    <?php } else { ?>
                                        <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                    <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-order-status"><?php echo $entry_callback_success_order_status; ?></label>
                        <div class="col-sm-10">
                            <select name="cointopay_callback_success_order_status_id" id="cointopay_callback_success_order_status_id" class="form-control">
                                <?php foreach ($order_statuses as $order_status) { ?>
                                    <?php if ($order_status['order_status_id'] == $cointopay_callback_success_order_status_id) { ?>
                                        <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                    <?php } else { ?>
                                        <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                    <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="entry-callback-order-status"><?php echo $entry_callback_failed_order_status; ?></label>
                        <div class="col-sm-10">
                            <select name="cointopay_callback_failed_order_status_id" id="cointopay_callback_failed_order_status_id" class="form-control">
                                <?php foreach ($order_statuses as $order_status) { ?>
                                    <?php if ($order_status['order_status_id'] == $cointopay_callback_failed_order_status_id) { ?>
                                        <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                    <?php } else { ?>
                                        <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                    <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="entry-redirect-url"><?php echo $entry_redirect_url; ?></label>
                        <div class="col-sm-10">
                            <label class="col-sm-12 control-label" style="font-weight: bold; text-align: left;" for="help-redirect-url-hint"><?php echo $help_redirect_url_hint; ?></label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-status"><?php echo $entry_status; ?></label>
                        <div class="col-sm-10">
                            <select name="cointopay_status" id="input-status" class="form-control">
                                <?php if ($cointopay_status) { ?>
                                    <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                                    <option value="0"><?php echo $text_disabled; ?></option>
                                <?php } else { ?>
                                    <option value="1"><?php echo $text_enabled; ?></option>
                                    <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<?php echo $footer; ?>