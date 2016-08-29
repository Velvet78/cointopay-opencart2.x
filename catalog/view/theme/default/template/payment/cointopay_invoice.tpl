<?php echo $header; ?>
<div class="container">
    <div class="row">
        <div id="content" class="col-sm-12">
            <fieldset>
                <?php if(isset($error)) { ?>
                    <div class="form-group">
                        <label class="col-sm-12 control-label"><?php echo $error;?></label>
                    </div>
                <?php }else{ ?>
                    <legend><?php echo $text_title;?></legend>
                    <div class="row">
                        <div class="col-sm-6 form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-4 control-label"><?php echo $text_transaction_id;?></label>
                                <div class="col-sm-8">
                                    <label class="control-label"><?php echo $TransactionID;?></label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label"><?php echo $text_address;?></label>
                                <div class="col-sm-8">
                                    <label class="control-label"><?php echo $coinAddress;?></label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label"><?php echo $text_amount;?></label>
                                <div class="col-sm-8">
                                    <label class="control-label"><?php echo $Amount;?></label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label"><?php echo $text_coinname;?></label>
                                <div class="col-sm-8">
                                    <label class="control-label"><?php echo $CoinName;?></label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label"></label>
                                <div class="col-sm-8">
                                    <label class="control-label"><img src="<?php echo $QRCodeURL;?>" /></label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label"><?php echo $text_pay_with_other;?></label>
                                <div class="col-sm-8">
                                    <label class="control-label"><a href="<?php echo $RedirectURL;?>" ><?php echo $text_clickhere;?></a></label>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div style="text-align: center;">
                                <img src="http://cointopay.com/img/logo.png" />
                            </div>
                            </br>
                            <div>
                                Cointopay International B.V. is providing crypto payment and web wallet services.
                                You can make and receive payments, but also offer your goods on the crypto market without the need to 
                                setup your own shopping cart. 
                                We are fully integrated with the banking system via Belfius bank and with payment service provider ICEPAY, 
                                this means we are fully enabled to serve you. Take full advantage now.
                                </br></br>
                                <strong>Pricing</strong></br></br>
                                We offer one payment model: Pay 0.5% per successful outgoing transaction.
                                Incoming transactions are free, as well as Cointopay T-Zero internal payments.</br></br>
                                <strong>Buy Crypto Coins</strong></br></br>
                                You can buy crypto currencies like BitCoin from us directly into your wallet. 
                                Register for an account, go to your dashboard, generate an invoice then pay it via other payment options. 
                                Once completed your coins will directly show up into your dashboard. Ready for sending!

                                Please note that the input currency has to be set to Euro, US Dollar or Chinese Yuan for the alternative payment button to appear. 
                                You are basically invoicing yourself.
                            </div>
                        </div>
                    </div>
                </fieldset>
            <?php } ?>
        </div>
    </div>
</div>
<?php echo $footer; ?>